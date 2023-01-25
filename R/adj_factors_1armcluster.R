#' @title Calculating the second term of Equation (5) from from Hedges & Citkowicz (2015, p. 1298)
#'
#' @description This function calculates a small cluster-design adjement factor which can be used
#' to adjusted effect sizes and their sampling variances from cluster-design studies
#' that adequately handles clustering. This factor in denoted a \eqn{\gamma}{\gamma} in
#' WWC (2021). The same notion is used here.
#'
#' @details When calculating effect sizes from cluster-designed studies, it recommended
#' (Hedges, 2007, 2011; Hedges & Citkowitz, 2015; WWC, 2021) to add an adjustment factor, \eqn{\gamma}{\gamma}
#' to \eqn{d}{d} whether or not cluster is adequately handled in the studies. Even if clustering
#' is adequately handled, WWC also recommend to use \eqn{\gamma}{\gamma} to adjust for
#' the variance component. The adjustment factor gamma is given by
#'
#' \deqn{\gamma  = 1 - \dfrac{(N^C+n-2)\rho}{N_2}}
#'
#' where \eqn{N^C}{N-C} is the sample size of the group without clustering, \eqn{n}{n} is
#' the average cluster size, and \eqn{\rho}{\rho} is the (often imputed) intraclass correlation.
#'
#' Then let the naive estimator of Hedges' \eqn{g}{g} be
#'
#' \deqn{g_{naive} = J\times \left(\dfrac{\bar{Y}^T_{\bullet\bullet} - \bar{Y}^C_{\bullet}}{S_T} \right)}
#'
#' where..
#'
#'
#' @references Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' What Works Clearinghouse (2021).
#' Supplement document for Appendix E and the What Works Clearinghouse procedures handbook, version 4.1
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf}
#'
#' @param N_total Numerical value indicating the total sample size of the study.
#' @param Nc Numerical value indicating the sample size of the arm/group that does not contain clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#' @param ICC Numerical value indicating the intra-class correlation (ICC) value.
#' @param sqrt Logical indicating if the square root of gamma should be calculated. Default = \code{TRUE}
#'
#' @return Returns a numerical value with (small) cluster-design corrector.
#'
#' @export
#'
#' @examples
#'
#' N <- 100
#' Nc <- 40
#' n <- 5
#' rho <- 0.1
#'
#' gamma_1armcluster(N_total = N, Nc = Nc, avg_grp_size = n, ICC = rho)
#'
#' # Testing function
#' sqrt(1 - (((Nc + n-2)*rho)/(N-2))) |> round(3)
#'


gamma_1armcluster <- function(N_total, Nc, avg_grp_size, ICC, sqrt = TRUE){

  n <- avg_grp_size
  N <- N_total
  rho <- ICC

  gamma <- 1 - (((Nc + n-2)*rho)/(N-2))


  if (sqrt){
    res <- sqrt(gamma)
  } else {
    res <- gamma
  }

  round(res, 3)

}
