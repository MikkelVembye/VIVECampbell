#'
#' @title Calculate and cluster bias adjust odds ratios (OR)
#'
#' @description This function calculated odds ratios based on various type of input/information,
#' as described in Table 11.10 from Borenstein and Hedges (2019, p. 226).
#'
#' @details
#' 2x2 table
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
#' Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' Higgins, J. P. T., Eldridge, S., & Li, T. (2019).
#' In J. P. T. Higgins, J. Thomas, J. Chandler, M. S. Cumpston, T. Li, M. Page, & V. Welch (Eds.),
#' \emph{Cochrane handbook for systematic reviews of interventions} (2nd ed., pp. 569–593).
#' Wiley Online Library. \doi{10.1002/9781119536604.ch23}
#'
#' @param A Upper left cell of an 2 X 2 frequency table.
#' @param B Upper right cell of an 2 X 2 frequency table.
#' @param C Lower left cell of an 2 X 2 frequency table.
#' @param D Lower right cell of an 2 X 2 frequency table.
#' @param p1 Risk/probability of an event in group 1 (usually the treatment group).
#' @param p2 Risk/probability of an event in group 2 (usually the control group).
#' @param n1 Sample size of group 1 (usually the treatment group).
#' @param n2 Sample size of group 2 (usually the control group).
#' @param OR Odds ratio estimate.
#' @param LL_OR Lower  bound of the 95% confidence interval of the odds ratio.
#' @param UL_OR Upper  bound of the 95% confidence interval of the odds ratio.
#' @param SE_OR Standard error of the odds ratio.
#' @param V_OR Sampling variance of the odds ratio.
#' @param Z Z-values from an normal distribution.
#' @param ICC Intra-class correlation.
#' @param avg_cl_size Average cluster size.
#' @param n_cluster_arms (Optional) Number of arm with clustering.
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
#' OR_calc(p1 = .2, p2 = .1, n1 = 100, n2 = 100)
#'
#' # Using raw OR and CIs
#' OR_calc(OR = 2.25, LL_OR = 1.5, UL_OR = 3)
#'
#' # Adding suffix to variables and selecting specific variables
#' OR_calc(A = 20, B = 80, C = 10, D = 90, add_name_to_vars = "_test", vars = OR_test)
#'
#' # Cluster bias adjustment when there is clustering in both groups
#' OR_calc(p1 = .53, p2 = .11, n1 = 20, n2 = 26, ICC = 0.1, avg_cl_size = 8, n_cluster_arms = 2)
#'
#' # Cluster bias adjustment when there is clustering in one group only
#' OR_calc(p1 = .53, p2 = .11, n1 = 20, n2 = 26, ICC = 0.1, avg_cl_size = 8, n_cluster_arms = 1)
#'
#'



OR_calc <- function(
    A = NULL, B = NULL, C = NULL, D = NULL,
    p1 = NULL, p2 = NULL, n1 = NULL, n2 = NULL,
    OR = NULL, LL_OR = NULL, UL_OR = NULL,
    SE_OR = NULL, V_OR = NULL, Z = 1.96,
    ICC = NULL, avg_cl_size = NULL,
    n_cluster_arms = 2,
    add_name_to_vars = NULL,
    vars = dplyr::everything()
    ) {

  if (!is.null(A) & !is.null(B) & !is.null(C) & !is.null(D)) {

    res <- tibble::tibble(

      OR = (A*D)/(B*C),
      ln_OR = log(OR),
      vln_OR = 1/A + 1/B + 1/C + 1/D

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      } else if (n_cluster_arms == 1){

        n <- avg_cl_size
        Nc <- C + D
        N <- A + B + C + D

        # Design effect from Hedges and Citkowicz (2015)
        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  } else if (!is.null(p1) & !is.null(p2) & !is.null(n1) & !is.null(n2)) {

    res <- tibble::tibble(

      OR = (p1*(1-p2))/(p2*(1-p1)),
      ln_OR = log(OR),
      vln_OR = 1/(n1*p1) + 1/(n1*(1-p1)) + 1/(n2*p2) + 1/(n2*(1-p2))

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  } else if (!is.null(LL_OR) & !is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((log(UL_OR) - log(LL_OR)) / (2*Z))^2

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        if (is.null(n1) || is.null(n2)){

          stop("Sample sizes (i.e., n1 and n2) must be specified to calculate the design effect")

        }

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  } else if (!is.null(LL_OR) & is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((ln_OR - log(LL_OR))/Z)^2

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        if (is.null(n1) || is.null(n2)){

          stop("Sample sizes (i.e., n1 and n2) must be specified to calculate the design effect")

        }

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }


  } else if (is.null(LL_OR) & !is.null(UL_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = ((log(UL_OR) - ln_OR)/Z)^2

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        if (is.null(n1) || is.null(n2)){

          stop("Sample sizes (i.e., n1 and n2) must be specified to calculate the design effect")

        }

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  } else if (!is.null(SE_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = log(SE_OR)^2

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        if (is.null(n1) || is.null(n2)){

          stop("Sample sizes (i.e., n1 and n2) must be specified to calculate the design effect")

        }

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  } else if (!is.null(V_OR)) {

    res <- tibble::tibble(

      OR = OR,
      ln_OR = log(OR),
      vln_OR = log(sqrt(V_OR))^2

    )

    if (!is.null(ICC) & !is.null(avg_cl_size)){

      if (n_cluster_arms == 2){

        DE <- 1 + (avg_cl_size - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )


      } else if (n_cluster_arms == 1){

        if (is.null(n1) || is.null(n2)){

          stop("Sample sizes (i.e., n1 and n2) must be specified to calculate the design effect")

        }

        n <- avg_cl_size
        Nc <- n2
        N <- n1 + n2

        DE <- 1 + ((n*Nc/N) - 1) * ICC

        res <- res |>
          dplyr::mutate(
            DE = DE,
            vln_OR_C = vln_OR * DE
          )

      }

    }

  }

  if (!is.null(add_name_to_vars)){

    if (!is.character(add_name_to_vars)){
      stop("add_name_to_vars only takes a character string as input")
    }

    res <- res |> dplyr::rename_with(~ paste0(.x, add_name_to_vars))

  }

  res |> dplyr::select({{vars}})

}
