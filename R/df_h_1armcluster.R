
#' @title 'Cluster bias correction when there is clustering in one treatment group only'
#'
#' @description This function calculates the degrees of freedom for studies
#' with clustering in one treatment group only, using Equation (7) from Hedges & Citkowicz (2015).
#'
#' @references Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' @param N_total Numerical value indicating the total sample size of the study.
#' @param ICC Numerical value indicating the intra-class correlation (ICC) value.
#' @param N_grp Numerical value indicating the sample size of the arm/group containing clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#'
#' @return Returns a numerical values indicating the cluster adjusted degrees of freedom.
#'
#' @export
#'
#' @examples
#' df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)


df_h_1armcluster <-
  function(N_total, ICC, N_grp, avg_grp_size){

  N <- N_total
  rho <- ICC
  NT <- N_grp
  n <- avg_grp_size

  h <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
    ((N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-2)*(1-rho)*rho)

  round(h, 2)
}
