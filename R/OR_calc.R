#'
#' @title Calculate odds ratios (OR)
#'
#' @description This function calculated odds ratios based on various type of input/information,
#' as described in Table 11.10 from Borenstein and Hedges (2019).
#'
#' @details
#' Add details
#'
#' |       |   | Event | Non-event | Total |
#' |-------|---|-------|-----------|-------|
#' |Treated|   |   A   |   B       |   n1  |
#' |Control|   |   C   |   D       |   n2  |
#'
#'
#' @references Borenstein and Hedges (2019).
#' Effect sizes for meta-analysis. In H. Cooper, L. V. Hedges, & J. C. Valentine (Eds.),
#' \emph{The handbook of research synthesis and meta-analysis} (3rd ed., pp. 207–242).
#' Russell Sage Foundation West Sussex.
#'
#' @param A Insert
#' @param B Insert
#' @param C Insert
#' @param D Insert
#' @param p1 Insert
#' @param p2 Insert
#' @param n1 Insert
#' @param n2 Insert
#' @param OR Insert
#' @param LL_OR Insert
#' @param UL_OR Insert
#' @param SE_OR Insert
#' @param V_OR Insert
#' @param Z Insert
#' @param add_name_to_vars Optional character string to be added to the variables names of the generated \code{tibble}.
#' @param vars Variables to be reported. Default is \code{NULL}. See Value section for further details.
#'
#' @note Read Borenstein and Hedges (2019) for further details.
#'
#' @return A \code{tibble} with information about OR, OR_LN, vln_OR.
#'
#' @export
#'
#' @examples
#'
#' # Using raw events
#' OR_calc(A = 20, B = 80, C = 10, D = 90)
#'
#' # Using proportions
#' OR_calc(p1 = .53, p2 = .11, n1 = 20, n2 = 26)
#'
#' # Using raw OR and CI
#' OR_calc(OR = 2.25, LL_OR = 1.5, UL_OR = 3)
#'
#' # Adding suffix to variables and selecting specific variables
#' OR_calc(A = 20, B = 80, C = 10, D = 90, add_name_to_vars = "_test", vars = OR_test)
#'
#'



OR_calc <- function(
    A = NULL, B = NULL, C = NULL, D = NULL,
    p1 = NULL, p2 = NULL, n1 = NULL, n2 = NULL,
    OR = NULL, LL_OR = NULL, UL_OR = NULL,
    SE_OR = NULL, V_OR = NULL, Z = 1.96,
    add_name_to_vars = NULL,
    vars = dplyr::everything()
    ) {

  if (!is.null(A) & !is.null(B) & !is.null(C) & !is.null(D)) {

    res <- tibble::tibble(

      OR = (A*D)/(B*C),
      ln_OR = log(OR),
      vln_OR = 1/A + 1/B + 1/C + 1/D

    )

  } else if (!is.null(p1) & !is.null(p2) & !is.null(n1) & !is.null(n2)) {

    res <- tibble::tibble(

      OR = (p1*(1-p2))/(p2*(1-p1)),
      ln_OR = log(OR),
      vln_OR = 1/(n1*p1) + 1/(n1*(1-p1)) + 1/(n2*p2) + 1/(n2*(1-p2))

    )

  } else if (!is.null(LL_OR) & !is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((log(UL_OR) - log(LL_OR)) / (2*Z))^2

    )

  } else if (!is.null(LL_OR) & is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((ln_OR - log(LL_OR))/Z)^2

    )
  } else if (is.null(LL_OR) & !is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((log(UL_OR) - ln_OR)/Z)^2

    )
  } else if (!is.null(SE_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = log(SE_OR)^2

    )
  } else if (!is.null(V_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = log(sqrt(V_OR))^2

    )
  }

  if (!is.null(add_name_to_vars)){

    if (!is.character(add_name_to_vars)){
      stop("add_name_to_vars only takes a character string as input")
    }

    res <- res |> dplyr::rename_with(~ paste0(.x, add_name_to_vars))

  }

  res |> dplyr::select({{vars}})

}
