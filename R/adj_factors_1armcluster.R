#' @title Small number of clusters correction when there is clustering in one treatment group only
#'
#' @description This function calculates a small cluster-design adjustment factor which can be used
#' to adjusted effect sizes and their sampling variances from cluster-design studies
#' that adequately handles clustering. This factor can be found in second term of Equation (5)
#' from from Hedges & Citkowicz (2015, p. 1298). The factor in denoted as \eqn{\gamma}{\gamma} in WWC (2021).
#' The same notion is used here and gave name to the function.
#'
#' @details When calculating effect sizes from cluster-designed studies, it recommended
#' (Hedges, 2007, 2011; Hedges & Citkowitz, 2015; WWC, 2021) to add an adjustment factor, \eqn{\gamma}{\gamma}
#' to \eqn{d}{d} whether or not cluster is adequately handled in the studies. Even if clustering
#' is adequately handled, WWC also recommend to use \eqn{\gamma}{\gamma} as a small number of clusters correction
#' to the variance component. The adjustment factor gamma when there is clustering in one
#' treatment group only is given by
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
#' where \eqn{J = 1 - 3/(4df-1)}, \eqn{\bar{Y}^T_{\bullet\bullet}} it the average treatment effect for the
#' treatment group containing clustering, \eqn{\bar{Y}^C_{\bullet}} is the average treatment effect
#' for the group without clustering, and \eqn{S_T} is the standard deviation ignoring clustering. To account for the
#' fact that \eqn{S_T} systematically underestimates the true standard deviation, \eqn{\sigma_T},
#' the cluster-adjusted effect size can be obtained from
#'
#' \deqn{g_T = g_{naive}\sqrt{\gamma}}
#'
#' if clustering is properly adjusted for, the sampling variance of \eqn{g_T} is given by
#'
#' \deqn{v_{g^T} = \left(\dfrac{1}{N^T} + \dfrac{1}{N^C}\right) \gamma + \dfrac{g^2_T}{2h} }
#'
#' where \eqn{N^T} is the sample size of the treatment group containing clustering and \eqn{h} is
#' given by
#'
#' \deqn{ h = \dfrac{[(N-2)(1-\rho) + (N^T-n)\rho]^2}
#' {(N-2)(1-\rho)^2 + (N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}}
#'
#' where \eqn{N}{N} is the total sample size.
#'
#' @references Hedges, L. V. (2007).
#' Effect sizes in cluster-randomized designs.
#' \emph{Journal of Educational and Behavioral Statistics}, 32(4), 341–370.
#' \doi{10.3102/1076998606298043}
#'
#' Hedges, L. V. (2011).
#' Effect sizes in three-level cluster-randomized experiments.
#' \emph{Journal of Educational and Behavioral Statistics}, 36(3), 346–380.
#' \doi{10.3102/1076998610376617}
#'
#' Hedges, L. V., & Citkowicz, M (2015).
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
#' @return Returns a numerical value for the cluster-design adjustment factor, \eqn{\gamma}.
#'
#' @seealso \code{\link{df_h_1armcluster}} for further details.
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
