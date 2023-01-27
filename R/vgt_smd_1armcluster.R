
#' @title Variance calculation when there is clustering in one treatment group only
#'
#' @description Insert
#'
#' @details Insert
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
#' @param N_cl_grp Insert
#' @param N_ind_grp Insert
#' @param avg_grp_size Insert
#' @param ICC Insert
#' @param g Insert
#' @param model Insert
#' @param not_cluster_adj Insert
#' @param prepost_cor Insert
#' @param F_val Insert
#' @param t_val Insert
#' @param SE Insert
#' @param S Insert
#' @param SE_std Insert
#'
#' @note Insert
#'
#' @return A \code{tibble} with info ...(Insert)...
#'
#' @seealso \code{\link{df_h_1armcluster}}, \code{\link{eta_1armcluster}},
#' \code{\link{gamma_1armcluster}}
#'
#' @export
#'
#' @examples
#' vgt_smd_1armcluster(
#' N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.1, g = 0.2,
#' model = "Posttest", not_cluster_adj = TRUE
#' )
#'

vgt_smd_1armcluster <-
  function(
    N_cl_grp, N_ind_grp, avg_grp_size, ICC, g,
    model = c("Posttest", "reg_coef", "reg_std_coef", "ANCOVA", "DiD"),
    not_cluster_adj = TRUE,
    prepost_cor = NULL, F_val = NULL, t_val = NULL, SE = NULL, S = NULL, SE_std = NULL

  ){

  N1 <- N_cl_grp
  N2 <- N_ind_grp
  N <- N1 + N2
  n <- avg_grp_size
  rho <- ICC
  h <- df_h_1armcluster(N_total = N, ICC = rho, N_grp = N_cl_grp, avg_grp_size = avg_grp_size)


  if ("Posttest" %in% model){


    if (is.numeric(N_cl_grp) && is.numeric(N_ind_grp) && is.numeric(t_val)){

      var_term1 <- g^2/t_val^2

    } else {

      var_term1 <- (1/N1 + 1/N2)

    }

    if (not_cluster_adj){

      eta <- eta_1armcluster(N_total = N, Nc = N_ind_grp, avg_grp_size = avg_grp_size, ICC = rho)

      vgt <- var_term1 * eta + g^2/(2*h)
      Wgt <- var_term1 * eta

    } else {

      gamma <- gamma_1armcluster(N_total = N, Nc = N_ind_grp, avg_grp_size = avg_grp_size, ICC = rho, sqrt = FALSE)

      vgt <- var_term1 * gamma + g^2/(2*h)
      Wgt <- var_term1 * gamma

    }

  }

  tibble::tibble(
    V_gt = vgt,
    W_gt = Wgt
  )

}
