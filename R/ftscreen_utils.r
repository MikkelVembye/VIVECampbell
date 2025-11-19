# --- File Processing Helper Functions ---

# Read protocol file content
.read_protocol_file <- function(protocol_file_path) {
  if (!file.exists(protocol_file_path)) stop(paste("Error: Protocol file does not exist:", protocol_file_path))
  
  protocol_ext <- tolower(tools::file_ext(protocol_file_path))
  supported_protocol_extensions <- c("txt", "md", "pdf", "docx")
  if (!protocol_ext %in% supported_protocol_extensions) stop(paste0("Error: Unsupported protocol file type '.", protocol_ext, "'. Supported extensions are: .", paste(supported_protocol_extensions, collapse = ", .")))
  
  tryCatch({
    protocol_content <- switch(protocol_ext,
      "txt" = ,
      "md" = paste(readLines(protocol_file_path, warn = FALSE), collapse = "\n"),
      "pdf" = {
        if (!requireNamespace("pdftools", quietly = TRUE)) stop("Package 'pdftools' required to read PDF protocols. Please install it.", call. = FALSE)
        paste(pdftools::pdf_text(protocol_file_path), collapse = "\n")
      },
      "docx" = {
        if (!requireNamespace("officer", quietly = TRUE)) stop("Package 'officer' required to read DOCX protocols. Please install it.", call. = FALSE)
        doc <- officer::read_docx(protocol_file_path)
        paste(officer::docx_summary(doc)$text[officer::docx_summary(doc)$content_type == "paragraph"], collapse = "\n")
      }
    )
    if (nchar(trimws(protocol_content)) == 0) stop("Protocol file appears to be empty or unreadable.")
    return(protocol_content)
  }, error = function(e) {
    stop(paste("Error reading protocol file:", e$message))
  })
}

# Combine files within a single directory
.combine_files_in_dir <- function(dir_path, temp_files_created) {
  files_in_dir <- list.files(dir_path, full.names = TRUE, recursive = FALSE)
  files_in_dir <- files_in_dir[!sapply(files_in_dir, dir.exists)]
  
  pdfs <- files_in_dir[tolower(tools::file_ext(files_in_dir)) == "pdf"]
  if (length(pdfs) > 1) {
    if (!requireNamespace("pdftools", quietly = TRUE)) {
      warning("Package 'pdftools' is required to combine PDFs. Processing them individually.", call. = FALSE)
      return(list(files = files_in_dir, temp_files = temp_files_created))
    }
    combined_pdf_path <- tempfile(pattern = paste0("combined_", basename(dir_path)), fileext = ".pdf")
    tryCatch({
      pdftools::pdf_combine(pdfs, output = combined_pdf_path)
      other_files <- files_in_dir[!files_in_dir %in% pdfs]
      return(list(files = c(combined_pdf_path, other_files), temp_files = c(temp_files_created, combined_pdf_path)))
    }, error = function(e) {
      warning(paste("Failed to combine PDFs in", dir_path, ". Processing them individually. Error:", e$message))
      return(list(files = files_in_dir, temp_files = temp_files_created))
    })
  }
  list(files = files_in_dir, temp_files = temp_files_created)
}

# Process file paths and directories
.process_file_paths <- function(file_path) {
  processed_file_paths <- c()
  temp_files_created <- c()
  
  for (p in file_path) {
    if (dir.exists(p)) {
      contents <- list.files(p, full.names = TRUE, recursive = FALSE)
      files_in_p <- contents[!sapply(contents, dir.exists)]
      processed_file_paths <- c(processed_file_paths, files_in_p)
      
      sub_dirs <- contents[sapply(contents, dir.exists)]
      for (sub_dir in sub_dirs) {
        result <- .combine_files_in_dir(sub_dir, temp_files_created)
        processed_file_paths <- c(processed_file_paths, result$files)
        temp_files_created <- result$temp_files
      }
    } else {
      processed_file_paths <- c(processed_file_paths, p)
    }
  }
  list(file_paths = unique(processed_file_paths), temp_files = temp_files_created)
}

# Clean up temporary files
.cleanup_temp_files <- function(temp_files_created) {
  if (length(temp_files_created) > 0) unlink(temp_files_created, force = TRUE)
}

# --- Argument Validation ---
.validate_ftscreen_args <- function(args) {
  if(any(!args$model %in% model_prizes$model)) stop("Unknown gpt model(s) used - check model name(s).")
  if (any(args$model == "gpt-4o") && args$reps > 1 && !args$force) stop("Error: Using 'gpt-4o' with reps > 1 requires setting 'force = TRUE'.")
  if (args$reps > 10 && !args$force) stop("* Are you sure you want to use ", args$reps, " iterations? If so, set 'force = TRUE'")
  
  allowed_extensions <- c("c", "cpp", "cs", "css", "doc", "docx", "go", "html", "java", "js", "json", "md", "pdf", "php", "pptx", "py", "rb", "sh", "tex", "ts", "txt")
  for (f_path in args$file_path) {
    if (!file.exists(f_path)) stop(paste("Error: File does not exist:", f_path))
    ext <- tolower(tools::file_ext(f_path))
    if (!ext %in% allowed_extensions) stop(paste0("Error: Unsupported file type for '", basename(f_path), "'. Extension '.", ext, "' is not supported."))
  }
}

# --- Result Aggregation ---
.aggregate_ft_res <- function(data, incl_cutoff_u, incl_cutoff_l) {
  sum_dat <- data |>
    dplyr::summarise(
      incl_p = mean(decision_binary == 1, na.rm = TRUE),
      final_decision_gpt = dplyr::case_when(
        incl_p < incl_cutoff_u & incl_p >= incl_cutoff_l ~ "Check",
        incl_p >= incl_cutoff_u ~ "Include",
        incl_p < incl_cutoff_l ~ "Exclude",
        TRUE ~ NA_character_
      ),
      final_decision_gpt_num = dplyr::case_when(
        incl_p >= incl_cutoff_l ~ 1,
        incl_p < incl_cutoff_l ~ 0,
        TRUE ~ NA_real_
      ),
      reps = dplyr::n(),
      n_mis_answers = sum(is.na(decision_binary)),
      .by = c(title, model, promptid, prompt)
    )

  if ("supplementary" %in% names(data)) {
    supplementary_final <- data |>
      dplyr::summarise(supplementary = if (any(supplementary == "yes", na.rm = TRUE)) "yes" else "no", .by = c(title, model, promptid))
    sum_dat <- dplyr::left_join(sum_dat, supplementary_final, by = c("title", "model", "promptid"))
  }

  if ("detailed_description" %in% names(data)) {
    long_answer_dat_sum <- data |>
      dplyr::mutate(
        incl_p = mean(decision_binary == 1, na.rm = TRUE),
        final_decision_gpt_num = dplyr::case_when(incl_p >= incl_cutoff_l ~ 1, incl_p < incl_cutoff_l ~ 0, TRUE ~ NA_real_),
        n_words_answer = stringr::str_count(detailed_description, '\\w+'),
        .by = c(title, model, promptid)
      ) |>
      dplyr::filter(decision_binary == final_decision_gpt_num) |>
      dplyr::arrange(title, model, promptid, desc(n_words_answer)) |>
      dplyr::summarise(longest_answer = detailed_description[1], .by = c(title, model, promptid))
    sum_dat <- dplyr::left_join(sum_dat, long_answer_dat_sum, by = c("title", "model", "promptid"))
  }
  
  tibble::new_tibble(sum_dat, class = "gpt_agg_tbl")
}

# --- Prompt Creation ---
.create_protocol_prompt <- function(protocol_content) {
  paste0(
    "You are conducting a systematic literature review using a predefined protocol.\n\n",
    "INSTRUCTIONS:\n",
    "1. Carefully read the full protocol below.\n",
    "2. Evaluate the study against EACH inclusion and exclusion criterion explicitly.\n",
    "3. Base your decision only on explicit evidence in the document (no speculation).\n\n",
    "PROTOCOL:\n",
    protocol_content,
    "\n\nINCLUSION DECISION GUIDANCE:\n",
    "- INCLUDE: All required inclusion criteria are met and no exclusion criteria apply.\n",
    "- EXCLUDE: Any inclusion criterion is not met or any exclusion criterion applies.\n",
    "- UNCERTAIN/CHECK: Insufficient information to decide confidently.\n\n",
    "Return the structured decision using the appropriate function call."
  )
}

.create_direct_prompt <- function(prompt) {
  paste0(
    "SCREENING QUESTION (treat this exact text as the ONLY task):\n",
    prompt, "\n\n",
    "INSTRUCTIONS:\n",
    "- Answer ONLY this question; ignore any earlier or unrelated criteria.\n",
    "- Do NOT reuse reasoning from previous questions; base answer solely on evidence for THIS question.\n",
    "- If the document gives no clear evidence, return the uncertain/check code (do not invent details).\n",
    "- Provide a concise rationale that mentions ONLY elements directly tied to THIS question.\n",
    "- Do not mention other screening questions.\n\n",
    "OUTPUT:\n",
    "- Return the inclusion decision via the function call.\n",
    "- Rationale must begin with: RATIONALE FOR QUESTION: followed by a direct justification."
  )
}

# --- Result DataFrame Creation ---
.create_result_df <- function(result_list, decision_description, status_message) {
  data.frame(
    studyid = result_list$studyid,
    title = result_list$title,
    promptid = result_list$promptid,
    prompt = result_list$prompt,
    model = result_list$model,
    iterations = result_list$iterations,
    question = result_list$prompt,
    top_p = result_list$top_p,
    decision_gpt = result_list$decision_gpt %||% NA_character_,
    detailed_description = if(decision_description && !is.null(result_list$detailed_description)) result_list$detailed_description else NA_character_,
    supplementary = result_list$supplementary %||% NA_character_,
    decision_binary = result_list$decision_binary %||% NA_real_,
    run_date = as.character(result_list$run_date),
    status_message = status_message,
    run_time = result_list$run_time,
    prompt_tokens = result_list$prompt_tokens,
    completion_tokens = result_list$completion_tokens,
    stringsAsFactors = FALSE
  )
}

# --- Model price data frame ---
# Models Prizes October 28 2024

mio <- 1000000

model_prizes <-
  data.frame(
    model = c(
      # GPT 3.5 models
      "gpt-3.5-turbo",
      "gpt-3.5-turbo-0125",
      "gpt-3.5-turbo-16k-0613",

      # GPT 4 models
      "gpt-4-32k",
      "gpt-4",
      "gpt-4-0613",
      "gpt-4-turbo-2024-04-09",
      "gpt-4-turbo",

      # GPT-4o models
      "gpt-4o",
      "gpt-4o-2024-08-06",
      "gpt-4o-2024-11-20",
      "gpt-4o-2024-05-13",

      # GPT-4o-mini models
      "gpt-4o-mini",
      "gpt-4o-mini-2024-07-18",

      # GPT-4.1 models
      "gpt-4.1",
      "gpt-4.1-2025-04-14",

      # GPT-4.1-mini models
      "gpt-4.1-mini",
      "gpt-4.1-mini-2025-04-14",

      # GPT-4.1-nano models
      "gpt-4.1-nano",
      "gpt-4.1-nano-2025-04-14",

      # GPT-4.5-preview models
      "gpt-4.5-preview",
      "gpt-4.5-preview-2025-02-27",

      # GPT-5 models
      "gpt-5",
      "gpt-5-2025-08-07",

      # GPT-5-mini models
      "gpt-5-mini",
      "gpt-5-mini-2025-08-07",

      # GPT-5-nano models
      "gpt-5-nano",
      "gpt-5-nano-2025-08-07"
    ),

    price_in_per_token = c(
      # GPT 3.5 models
      0.5/mio, # gpt-3.5-turbo (refers currently to gpt-3.5-turbo-0125)
      0.5/mio, # gpt-3.5-turbo-0125
      3/mio,   # gpt-3.5-turbo-16k-0613

      # GPT 4 models
      60/mio,  # gpt-4-32k
      30/mio,  # gpt-4
      30/mio,  # gpt-4-0613
      10/mio,  # gpt-4-turbo-2024-04-09
      10/mio,  # gpt-4-turbo

      # GPT-4o models
      2.5/mio, # gpt-4o
      2.5/mio, # gpt-4o-2024-08-06
      2.5/mio, # gpt-4o-2024-11-20
      5/mio,   # gpt-4o-2024-05-13

      # GPT-4o-mini models
      0.15/mio, # gpt-4o-mini
      0.15/mio, # gpt-4o-mini-2024-07-18

      # GPT-4.1 models
      2/mio,   # gpt-4.1
      2/mio,   # gpt-4.1-2025-04-14

      # GPT-4.1-mini models
      0.4/mio, # gpt-4.1-mini
      0.4/mio, # gpt-4.1-mini-2025-04-14

      # GPT-4.1-nano models
      0.1/mio, # gpt-4.1-nano
      0.1/mio, # gpt-4.1-nano-2025-04-14

      # GPT-4.5-preview models
      75/mio,  # gpt-4.5-preview
      75/mio,   # gpt-4.5-preview-2025-02-27

      # GPT-5 models
      1.25/mio, # gpt-5
      1.25/mio, # gpt-5-2025-08-07

      # GPT-5-mini models
      0.25/mio,  # gpt-5-mini
      0.25/mio,  # gpt-5-mini-2025-08-07

      # GPT-5-nano models
      0.05/mio, # gpt-5-nano
      0.05/mio  # gpt-5-nano-2025-
    ),

    price_out_per_token = c(
      # GPT 3.5 models
      1.5/mio, # gpt-3.5-turbo (refers currently to gpt-3.5-turbo-0125)
      1.5/mio, # gpt-3.5-turbo-0125
      4/mio,   # gpt-3.5-turbo-16k-0613

      # GPT 4 models
      120/mio, # gpt-4-32k
      60/mio,  # gpt-4
      60/mio,  # gpt-4-0613
      30/mio,  # gpt-4-turbo-2024-04-09
      30/mio,  # gpt-4-turbo

      # GPT-4o models
      10/mio,  # gpt-4o
      10/mio,  # gpt-4o-2024-08-06
      10/mio,  # gpt-4o-2024-11-20
      15/mio,  # gpt-4o-2024-05-13

      # GPT-4o-mini models
      0.6/mio, # gpt-4o-mini
      0.6/mio, # gpt-4o-mini-2024-07-18

      # GPT-4.1 models
      8/mio,   # gpt-4.1
      8/mio,   # gpt-4.1-2025-04-14

      # GPT-4.1-mini models
      1.6/mio, # gpt-4.1-mini
      1.6/mio, # gpt-4.1-mini-2025-04-14

      # GPT-4.1-nano models
      0.4/mio, # gpt-4.1-nano
      0.4/mio, # gpt-4.1-nano-2025-04-14

      # GPT-4.5-preview models
      150/mio, # gpt-4.5-preview
      150/mio,  # gpt-4.5-preview-2025-02-27

      # GPT-5 models
      10/mio,  # gpt-5
      10/mio,  # gpt-5-2025-08-07

      # GPT-5-mini models
      2/mio,   # gpt-5-mini
      2/mio,   # gpt-5-mini-2025-08-

      # GPT-5-nano models
      0.4/mio, # gpt-5-nano
      0.4/mio  # gpt-5-nano-2025-08-07
    )
  )

# Function to get input price per token for a given model
.input_price <-
  function(x){

    model_prizes |> dplyr::filter(model == x) |> dplyr::pull(price_in_per_token)

  }

# Function to get output price per token for a given model
.output_price <-
  function(x){

    model_prizes |> dplyr::filter(model == x) |> dplyr::pull(price_out_per_token)

  }