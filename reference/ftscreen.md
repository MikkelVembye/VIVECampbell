# Full-text screening with OpenAI API models

Performs full-text screening with OpenAI Assistants API models over
local documents (PDF, TXT, DOCX, etc.). You can supply either a single
protocol file or one/many direct prompts; the function can repeat
questions (`reps`) to assess answer consistency. Native (structured)
function calling is used to standardize outputs.

A two-phase workflow is used:

1.  Supplementary detection (precomputation): For every unique input
    file a short, standalone assistant run is executed that ONLY calls
    the `supplementary_check` tool. Its single yes/no outcome is
    normalized ("yes"/"no"/NA) and cached.

2.  Screening runs: Each (file × prompt × repetition × model) run reuses
    the cached supplementary value. The main assistant is created
    WITHOUT the `supplementary_check` tool. This prevents drift, saves
    tokens, and ensures a single authoritative value per file.

Fallback: If the precomputation fails for a file (result = NA), the
screening runs for that file automatically include the
`supplementary_check` tool and allow the model to call it inline (once
per run) so a value can still be produced.

## Usage

``` r
ftscreen(
  file_path,
  prompt = NULL,
  protocol_file_path = NULL,
  api_key = AIscreenR::get_api_key(),
  vector_stores_name,
  model = "gpt-4o-mini",
  top_p = 1,
  temperature = 0.7,
  decision_description = FALSE,
  assistant_name = "file assistant screening",
  assistant_description =
    "Function-calling assistant for full-text screening that MUST return answers exclusively via a single required tool/function call (no plain-text replies). Reviews a file and decides inclusion/exclusion/uncertain per a protocol or prompt.",
  assistant_instructions =
    "You are a function-calling assistant for full-text screening.\n\nCRITICAL REQUIREMENTS:\n- Always return your answer by emitting EXACTLY ONE tool/function call required for the task.\n- Do NOT output plain text answers; do NOT call any other tools.\n- If the prompt/instructions indicate supplementary presence is precomputed, do NOT call supplementary_check.\n\nTASK:\n- Review the attached file strictly against the provided protocol or prompt.\n- Decide include (1), exclude (0), or unclear (1.1). When detailed mode is enabled, provide the rationale via the tool fields.\n\nOUTPUT:\n- Only the single function call with the appropriate arguments.",
  messages = TRUE,
  reps = 1,
  max_tries = 16,
  time_info = TRUE,
  token_info = TRUE,
  max_seconds = NULL,
  is_transient = .gpt_is_transient,
  backoff = NULL,
  after = NULL,
  rpm = 10000,
  seed_par = NULL,
  progress = TRUE,
  incl_cutoff_upper = 0.5,
  incl_cutoff_lower = 0.4,
  force = FALSE,
  sleep_time = 8,
  ...
)
```

## Arguments

- file_path:

  A character vector of file paths or directories to be screened.
  Directories will be processed recursively, with files in
  sub-directories being combined into a single document for screening.

- prompt:

  A character string containing the screening prompt. Required if
  `protocol_file_path` is not provided.

- protocol_file_path:

  Path to a file (.txt, .md, .pdf, .docx) containing the screening
  protocol.

- api_key:

  Your OpenAI API key. Defaults to `get_api_key()`. Imported from
  AIscreenR package.

- vector_stores_name:

  A name for the OpenAI vector store to be created for the screening
  session.

- model:

  Character string with the name of the completion model. Can take
  multiple OpenAI models. Default = `"gpt-4o-mini"`. Find available
  models at <https://platform.openai.com/docs/models>.

- top_p:

  An alternative to sampling with temperature, called nucleus sampling,
  where the model considers the results of the tokens with top_p
  probability mass. So 0.1 means only the tokens comprising the top 10%
  probability mass are considered. OpenAI recommends altering this or
  temperature but not both. Default is 1.

- temperature:

  Controls randomness: lowering results in less random completions. As
  the temperature approaches zero, the model will become deterministic
  and repetitive. Default is 0.7.

- decision_description:

  Logical indicating whether to include detailed descriptions of
  decisions. Default is `FALSE`.

- assistant_name, assistant_description, assistant_instructions:

  Configuration for the OpenAI assistant.

- messages:

  Logical indicating whether to print messages embedded in the function.
  Default is `TRUE`.

- reps:

  Numerical value indicating the number of times the same question
  should be sent to OpenAI's API models. This can be useful to test
  consistency between answers. Default is `1`.

- max_tries, max_seconds:

  Cap the maximum number of attempts with `max_tries` or the total
  elapsed time from the first request with `max_seconds`. If neither
  option is supplied, it will not retry.

- time_info:

  Logical indicating whether the run time of each request/question
  should be included in the data. Default = `TRUE`.

- token_info:

  Logical indicating whether the number of prompt and completion tokens
  per request should be included in the output data. Default = `TRUE`.

- is_transient:

  A predicate function that takes a single argument (the response) and
  returns `TRUE` or `FALSE` specifying whether or not the response
  represents a transient error.

- backoff:

  A function that takes a single argument (the number of failed attempts
  so far) and returns the number of seconds to wait.

- after:

  A function that takes a single argument (the response) and returns
  either a number of seconds to wait or `NULL`, which indicates that the
  `backoff` strategy should be used instead.

- rpm:

  Numerical value indicating the number of requests per minute (rpm)
  available for the specified api key.

- seed_par:

  Numerical value for a seed to ensure that proper, parallel-safe random
  numbers are produced.

- progress:

  Logical indicating whether a progress bar should be shown when running
  the screening in parallel. Default is `TRUE`.

- incl_cutoff_upper:

  Numerical value indicating the probability threshold for which a study
  should be included. Default is 0.5.

- incl_cutoff_lower:

  Numerical value indicating the probability threshold above which
  studies should be checked by a human. Default is 0.4.

- force:

  Logical argument indicating whether to force the function to use more
  than 10 iterations or certain models. Default is `FALSE`.

- sleep_time:

  Time in seconds to wait between checking run status. Default is 8.

- ...:

  Further arguments to pass to the request body.

## Value

An object of class `gpt_ftscreen` containing:

- answer_data:

  Row per (file × prompt × repetition × model) with decisions and cached
  supplementary value.

- answer_data_aggregated:

  Aggregated inclusion probabilities (present when multiple prompts,
  models, or reps).

- error_data:

  Rows where a decision could not be derived (if any).

- run_date:

  Date of execution.

- n_files, n_prompts, n_models, n_combinations, n_runs:

  Processing counts.

- price_dollar:

  Total estimated cost of the screening (in dollars) based on actual
  token usage.

- price_data:

  A tibble with detailed price breakdown per prompt/model/iteration.

## Note

The `answer_data_aggregated` data (only present when reps \> 1) contains
the following variables:

|                            |             |                                                                                     |
|----------------------------|-------------|-------------------------------------------------------------------------------------|
| **title**                  | `character` | The filename of the screened document.                                              |
| **model**                  | `character` | The specific model used.                                                            |
| **promptid**               | `integer`   | The prompt ID.                                                                      |
| **prompt**                 | `character` | The prompt used for screening.                                                      |
| **incl_p**                 | `numeric`   | The probability of inclusion across repeated responses.                             |
| **final_decision_gpt**     | `character` | The final decision: 'Include', 'Exclude', or 'Check'.                               |
| **final_decision_gpt_num** | `integer`   | The final numeric decision: 1 for include/check, 0 for exclude.                     |
| **reps**                   | `integer`   | The number of repetitions for the question.                                         |
| **n_mis_answers**          | `integer`   | The number of missing responses.                                                    |
| **supplementary**          | `character` | Indicates if supplementary material was detected ('yes'/'no').                      |
| **longest_answer**         | `character` | The longest detailed description from responses (if `decision_description = TRUE`). |

  
The `answer_data` data contains the following variables:

|                          |             |                                                                            |
|--------------------------|-------------|----------------------------------------------------------------------------|
| **studyid**              | `integer`   | The study ID of the file.                                                  |
| **title**                | `character` | The filename of the screened document.                                     |
| **promptid**             | `integer`   | The prompt ID.                                                             |
| **prompt**               | `character` | The prompt used for screening.                                             |
| **model**                | `character` | The specific model used.                                                   |
| **iterations**           | `numeric`   | The repetition number for the question.                                    |
| **decision_gpt**         | `character` | The raw decision from the model ('1', '0', or '1.1').                      |
| **detailed_description** | `character` | A detailed description of the decision (if `decision_description = TRUE`). |
| **supplementary**        | `character` | Indicates if supplementary material was detected ('yes'/'no').             |
| **decision_binary**      | `integer`   | The binary decision (1 for inclusion/uncertainty, 0 for exclusion).        |
| **run_time**             | `numeric`   | The time taken for the request.                                            |
| **prompt_tokens**        | `integer`   | The number of prompt tokens used.                                          |
| **completion_tokens**    | `integer`   | The number of completion tokens used.                                      |

## Examples

``` r
if (FALSE) { # \dontrun{

set_api_key()

file_path <- "path/to/your/full_text_files"
protocol_file <- "path/to/your/protocol_file.txt"

# --- Run screening using the protocol file ---
result_protocol <- ftscreen(
  file_path = file_path,
  protocol_file_path = protocol_file,
  vector_stores_name = "TestFTScreenProtocol",
  model = "gpt-4o-mini",
  decision_description = TRUE,
  reps = 1,
  assistant_instructions = "
  You are a helpful agent that reviews files to determine their relevance based on specific protocols.

  CRITICAL: You must follow this EXACT two-step process:

  STEP 1: SUPPLEMENTARY CHECK ONLY
  - Use the supplementary_check function to identify if the text contains references to
    supplementary materials, appendices, or additional information.
  - This step is ONLY about identifying supplementary content - do NOT make any inclusion decisions here.

  STEP 2: PROTOCOL EVALUATION AND INCLUSION DECISION
  - Carefully review the provided protocol criteria.
  - Evaluate the study against ALL relevant criteria in the protocol.
  - Base your decision solely on whether the study meets the protocol criteria.

  IMPORTANT REMINDERS:
  - The supplementary check is separate from the inclusion decision.
  - If the study meets the protocol criteria, then it should be included in further studies.
  - Be explicit about whether the study should be included or excluded based on the protocol evaluation.
  - Provide detailed reasoning for your decision when detailed_description is enabled"
)

print(result_protocol$answer_data)


# --- Run screening using traditional prompts ---

prompts <- c("
Does this study focus on an intervention aimed at improving children's language, 
reading/literacy, or mathematical skills?
",
"Is this study written in English?",
"Does this study involve children aged 3 to 4 years old?"
)

result_prompts <- ftscreen(
  file_path = file_path,
  prompt = prompts,
  vector_stores_name = "TestFTScreenPrompts",
  model = "gpt-4o-mini",
  decision_description = TRUE,
  reps = 1
)

print(result_prompts$answer_data)
} # }
```
