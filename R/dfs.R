
###################################################
# WWC and Pustejovsky calculation
###################################################

#' @title Degrees of freedom calculation for cluster bias correction for standardized mean differences
#'
#' @description This function calculates the degrees of freedom for studies
#' with clustering, using Equation (E.21) from WWC (2022, p. 171). Can also be found
#' as h in WWC (2021). When \code{df_type = "Pustejovsky"}, the function calculates the
#' degrees of freedom, using the upsilon formula from Pustejovsky (2016, find under
#' the Cluster randomized trials section). See further details below.
#'
#' @details When clustering is present the \eqn{N-2}{N-2} degrees of freedom (\eqn{df}{df}) will be a rather liberal choice,
#' partly overestimating the small sample corrector \eqn{J}{J} and partly underestimating
#' the true variance of (Hedges') \eqn{g_T}{g-T}. The impact of the calculated \eqn{df}{df} will be most
#' consequential for small (sample) studies. To overcome these issues, \eqn{df}{df}
#' can instead be calculated in at least to different way. The What Works
#' Clearinghouse suggests using the following formula
#'
#' \deqn{ h = \dfrac{[(N-2)-2(n-1)\rho]^2}
#' {(N-2)(1-\rho)^2 + n(N-2n)\rho^2 + 2(N-2n)\rho(1-\rho)}}
#'
#' where \eqn{N}{N} is the total sample size, \eqn{n}{n} is average cluster size and
#' \eqn{\rho}{\rho} is the (imputed) intraclass correlation. Alternatively,
#' Pustejovsky (2016) suggests using the following formula to calculate degrees of freedom
#' cluster randomized trials
#'
#' \deqn{ \upsilon = \dfrac{n^2M(M-2)}
#' {M[(n-1)\rho^2 + 1]^2 + (M-2)(n-1)(1-\rho^2)^2}}
#'
#' where \eqn{M}{M} is the number of cluster which can also be calculated from \eqn{N/n}{N/n}. \cr
#'
#' @note Read Taylor et al. (2020) to understand why we use the \eqn{g_T}{g-T} notation.
#' Find suggestions for how and which ICC values to impute when these are unknown (Hedges & Hedberg, 2007, 2013).
#'
#' @references Hedges, L. V., & Hedberg, E. C. (2007).
#' Intraclass correlation values for planning group-randomized trials in education.
#' \emph{Educational Evaluation and Policy Analysis}, 29(1), 60–87.
#' \doi{10.3102/0162373707299706}
#'
#' Hedges, L. V., & Hedberg, E. C. (2013).
#' Intraclass correlations and covariate outcome correlations for planning
#' two- and three-Level cluster-randomized experiments in education.
#' \emph{Evaluation Review}, 37(6), 445–489. \doi{10.1177/0193841X14529126}
#'
#' Pustejovsky (2016).
#' Alternative formulas for the standardized mean difference.
#' \url{https://www.jepusto.com/alternative-formulas-for-the-smd/}
#'
#' Taylor, J.A., Pigott, T.D., & Williams, R. (2020)
#' Promoting knowledge accumulation about intervention effects:
#' Exploring strategies for standardizing statistical approaches and effect size reporting.
#' \emph{Educational Researcher}, 51(1), 72-80. \doi{10.3102/0013189X211051319}
#'
#' What Works Clearinghouse (2021).
#' Supplement document for Appendix E and the What Works Clearinghouse procedures handbook, version 4.1
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf}
#'
#' What Works Clearinghouse (2022).
#' What Works Clearinghouse Procedures and Standards Handbook, Version 5.0.
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/Final_WWC-HandbookVer5_0-0-508.pdf}
#'
#' @template dfs-arg
#' @param df_type Character indicating how the degrees of freedom are calculated.
#' Default is \code{"WWC"}, which uses WWCs Equation E.21 (2022, p. 171). Alternative is \code{"Pustejovsky"},
#' which uses the upsilon formula from Pustejovsky (2016).
#'
#' @return Returns a numerical value indicating the cluster adjusted degrees of freedom.
#'
#' @export
#'
#' @examples
#' df_h(N_total = 100, ICC = 0.1, avg_grp_size = 5)
#'
#' df_h(N_total = 100, ICC = 0.1, avg_grp_size = 5, df_type = "Pustejovsky")
#'

df_h <- function(N_total, ICC, avg_grp_size = NULL, n_clusters = NULL, df_type = "WWC"){

  if ("WWC" %in% df_type){

    if (length(N_total) == 1){
      N <- N_total
    } else {
      N <- sum(N_total)
    }

    rho <- ICC

    if (!is.null(avg_grp_size) & is.null(n_clusters)){

      n <- avg_grp_size

    } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

      n <- round(N/n_clusters)

    } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

      n <- avg_grp_size
      n_test <- round(N/n_clusters)

      if (n != n_test) {

        warning(paste0("The average cluster size diverges between the specified ",
                       "average group size and the N_total/n_clusters calculation"))
      }

    }

    h <- ((N-2) - 2 * (n-1) * rho)^2 /
      ((N-2) * (1-rho)^2 + n * (N-2*n) * rho^2 + 2*(N-2*n)*rho*(1-rho))

    df <- round(h, 2)

  }

  if ("Pustejovsky" %in% df_type){

    if (length(N_total) == 1){
      N <- N_total
    } else {
      N <- sum(N_total)
    }

    rho <- ICC

    if (!is.null(avg_grp_size) & is.null(n_clusters)){

      n <- avg_grp_size

    } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

      n <- round(N/n_clusters)

    } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

      n <- avg_grp_size
      n_test <- round(N/n_clusters)

      if (n != n_test) {

        warning(paste0("The average cluster size diverges between the specified ",
                       "average group size and the N_total/n_clusters calculation"))
      }

    }

    if (is.null(n_clusters)){

      M <- N/n

    } else {

      M <- n_clusters

    }

    upsilon <- (n^2*M * (M-2)) / (M*((n-1)*rho + 1)^2 + (M-2) * (n-1) * (1-rho)^2)

    df <- round(upsilon, 2)

  }

  df

}


###################################################
# One arm clustering calculation
###################################################


#' @title Degrees of freedom calculation for cluster bias correction when there is clustering in one treatment group only
#'
#' @description This function calculates the degrees of freedom for studies
#' with clustering in one treatment group only, using Equation (7) from Hedges & Citkowicz (2015).
#'
#' @details When clustering is present the \eqn{N-2}{N-2} degrees of freedom (\eqn{df}{df}) will be a rather liberal choice,
#' partly overestimating the small sample corrector \eqn{J}{J} and partly underestimating
#' the true variance of (Hedges') \eqn{g_T}{g-T}. The impact of the calculated \eqn{df}{df} will be most
#' consequential for small (sample) studies. To overcome these issues,
#' Hedges & Citkowicz (2015) suggest obtaining the degrees of freedom from
#'
#' \deqn{ h = \dfrac{[(N-2)(1-\rho) + (N^T-n)\rho]^2}
#' {(N-2)(1-\rho)^2 + (N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}}
#'
#' where \eqn{N}{N} is the total sample size, \eqn{N^T}{N-T} is the sample size of the treatment group,
#' containg clustering, \eqn{n}{n} is average cluster size and
#' \eqn{\rho}{\rho} is the (imputed) intraclass correlation.
#'
#' @note Read Taylor et al. (2020) to understand why we use the \eqn{g_T}{g-T} notation.
#' Find suggestions for how and which ICC values to impute when these are unknown (Hedges & Hedberg, 2007, 2013).
#'
#' @references Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' Hedges, L. V., & Hedberg, E. C. (2007).
#' Intraclass correlation values for planning group-randomized trials in education.
#' \emph{Educational Evaluation and Policy Analysis}, 29(1), 60–87.
#' \doi{10.3102/0162373707299706}
#'
#' Hedges, L. V., & Hedberg, E. C. (2013).
#' Intraclass correlations and covariate outcome correlations for planning
#' two- and three-Level cluster-randomized experiments in education.
#' \emph{Evaluation Review}, 37(6), 445–489. \doi{10.1177/0193841X14529126}
#'
#' Taylor, J.A., Pigott, T.D., & Williams, R. (2020)
#' Promoting knowledge accumulation about intervention effects:
#' Exploring strategies for standardizing statistical approaches and effect size reporting.
#' \emph{Educational Researcher}, 51(1), 72-80. \doi{10.3102/0013189X211051319}
#'
#'
#' @param N_total Numerical value indicating the total sample size of the study.
#' @param ICC Numerical value indicating the intra-class correlation (ICC) value.
#' @param N_grp Numerical value indicating the sample size of the arm/group containing clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#' @param n_clusters Numerical value indicating the number of clusters in the treatment group.
#'
#' @return Returns a numerical value indicating the cluster adjusted degrees of freedom.
#'
#' @export
#'
#' @examples
#' df <- df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)
#' df
#'
#'
#' # Testing function
#' N <- 100
#' rho <- 0.1
#' NT <- 60
#' n <- 5
#'
#' df_raw <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
#'           ( (N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho )
#'
#' round(df_raw, 2)
#'
#'


df_h_1armcluster <-
  function(N_total, ICC, N_grp, avg_grp_size = NULL, n_clusters = NULL){

  if (length(N_total) == 1){
    N <- N_total
  } else {
    N <- sum(N_total)
  }

  rho <- ICC
  NT <- N_grp

  if (!is.null(avg_grp_size) & is.null(n_clusters)){

    n <- avg_grp_size

  } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

    n <- round(N_grp/n_clusters)

  } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

    n <- avg_grp_size
    n_test <- round(N_grp/n_clusters)

    if (n != n_test) {

    warning(paste0("The average cluster size diverges between the specified ",
             "average group size and the N_total/n_clusters calculation"))
    }

  }

  h <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
    ((N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho)

  round(h, 2)

}




