
#' @title Variance calculation when there is clustering in one treatment group only
#'
#' @description This function calculates the sampling variance estimates for effect sizes
#' obtained from cluster-designed studies. This include measures of the sampling variance,
#' a modified variance estimate for publication bias testing, and a variance-stabilized
#' transformed effect size and variance as presented in Pustejovsky & Rodgers (2019).
#'
#' @details
#' Table 1 illustrates all cluster adjustment
#' of variance estimates from pre-test and/or covariate-adjusted measures that can
#' be calculated with the vgt_smd_1armcluster()
#'
#'  ***Table 1***<br>
#' *Sampling variance estimates for \eqn{g_T} across various models for handling cluster, estimation techniques, and reported quantities.*
#' | **Calculation type/<br>reported quantities**           | **Cluster-adjusted (model)<br>sampling variance**                                       | **Not cluster-adjusted (model)<br>sampling variance**                                |
#' | --------------------                                   | ------------------                                                                      | -------------------                                                                  |
#' | ANCOVA, adj. means<br>\eqn{R^2, N^T, N^C}              | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}|
#' | ANCOVA, adj. means<br>\eqn{R^2_{imputed}, N^T, N^C}    | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}|
#' | ANCOVA, adj. means<br>\eqn{F, (t^2), N^T, N^C}         | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2(h-q)}.}                       | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2(h-q)}.}                      |
#' | ANCOVA, pretest only<br>\eqn{F, (t^2), N^T, N^C}       | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2h}.}                           | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2h}.}                          |
#' | ANCOVA, pretest only<br>\eqn{r, N^T, N^C}              | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}    |
#' | Reg coef<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2(h-q)}.}                      | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2(h-q)}.}                     |
#' | Reg coef, pretest only<br>\eqn{SE, S_T, N^T, N^C}      | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2h}.}                          | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2h}.}                         |
#' | Std. reg coef<br>\eqn{SE_{std}, N^T, N^C}              | \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2(h-q)}.}                                         | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2(h-q)}.}                                        |
#' | Std. reg coef, pretest only<br>\eqn{SE_{std}, N^T, N^C}| \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2h}.}                                             | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2h}.}                                            |
#' | DiD, gain scores<br>\eqn{r, N^T, N^C}                  | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}      | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}     |
#' | DiD, gain scores<br>\eqn{r_{imputed}, N^T, N^C}        | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}    |
#' | DiD, gain scores<br>\eqn{t, N^T, N^C}                  | \eqn{\left(\frac{g^2}{t^2}\right) \gamma + \frac{g^2_T}{2h}.}                           | \eqn{\left(\frac{g^2}{t^2}\right) \eta + \frac{g^2_T}{2h}.}                          |
#'
#'
#' *Note*: \eqn{R^2} "is the multiple correlation between the covariates and the outcome" (WWC, 2021),
#' \eqn{\eta = 1 - (N^C+n-2)\rho/(N-2)}, see \code{\link{eta_1armcluster}},
#' \eqn{\gamma = 1 - (N^C+n-2)\rho/(N-2)}, see \code{\link{eta_1armcluster}},
#' \eqn{r} is the pre-posttest correlation, and \eqn{q} is the number of covariates. Std. = standardized.
#'
#' "It is often desired in practice to adjust for multiple baseline characteristics.
#' The problem of \eqn{q} covariates is a straightforward extension of the single covariate case
#' (...): The correlation coefficient estimate \eqn{r} is now obtained by
#' taking the square root of the coefficient of multiple determination, \eqn{R^2}"
#' (Hedges et al. 2023, p. 17) and \eqn{df = h-q}.
#'
#' **Calculating modified measures of variance  for publication bias testing**
#'
#' ***Table 2***<br>
#' *Sampling variance estimates for \eqn{g_T} across various models for handling cluster, estimation techniques, and reported quantities.*
#' | **Calculation type/<br>reported quantities**           | **Cluster-adjusted (model)<br>sampling variance**               | **Not cluster-adjusted (model)<br>sampling variance**         |
#' | --------------------                                   | ------------------                                              | -------------------                                           |
#' | ANCOVA, adj. means<br>\eqn{R^2, N^T, N^C}              | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma} | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta }|
#' | ANCOVA, adj. means<br>\eqn{R^2_{imputed}, N^T, N^C}    | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma} | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta }|
#' | ANCOVA, adj. means<br>\eqn{F, (t^2), N^T, N^C}         | \eqn{\left(\frac{g^2_T}{F}\right) \gamma}                       | \eqn{\left(\frac{g^2_T}{F}\right) \eta}                       |
#' | ANCOVA, pretest only<br>\eqn{F, (t^2), N^T, N^C}       | \eqn{\left(\frac{g^2_T}{F}\right) \gamma}                       | \eqn{\left(\frac{g^2_T}{F}\right) \eta}                       |
#' | ANCOVA, pretest only<br>\eqn{r, N^T, N^C}              | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma} | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta} |
#' | Reg coef<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma }                     | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta}                      |
#' | Reg coef, pretest only<br>\eqn{SE, S_T, N^T, N^C}      | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma}                      | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta}                      |
#' | Std. reg coef<br>\eqn{SE_{std}, N^T, N^C}              | \eqn{SE^2_{std} \gamma }                                        | \eqn{SE^2_{std} \eta}                                         |
#' | Std. reg coef, pretest only<br>\eqn{SE_{std}, N^T, N^C}| \eqn{SE^2_{std} \gamma}                                         | \eqn{SE^2_{std} \eta}                                         |
#' | DiD, gain scores<br>\eqn{r, N^T, N^C}                  | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma}  | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta}  |
#' | DiD, gain scores<br>\eqn{r_{imputed}, N^T, N^C}        | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma} | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta} |
#' | DiD, gain scores<br>\eqn{t, N^T, N^C}                  | \eqn{\left(\frac{g^2}{t^2}\right) \gamma}                       | \eqn{\left(\frac{g^2}{t^2}\right) \eta}                       |
#'
#'
#' *Note*: \eqn{R^2} "is the multiple correlation between the covariates and the outcome" (WWC, 2021),
#' \eqn{\eta = 1 - (N^C+n-2)\rho/(N-2)}, see \code{\link{eta_1armcluster}},
#' \eqn{\gamma = 1 - (N^C+n-2)\rho/(N-2)}, see \code{\link{eta_1armcluster}}, and
#' \eqn{r} is the pre-posttest correlation. Std. = standardized.
#'
#' "It is often desired in practice to adjust for multiple baseline characteristics.
#' The problem of \eqn{q} covariates is a straightforward extension of the single covariate case
#' (...): The correlation coefficient estimate \eqn{r} is now obtained by
#' taking the square root of the coefficient of multiple determination, \eqn{R^2}"
#' (Hedges et al. 2023, p. 17) and \eqn{df = h-q}.
#'
#'
#' @references Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' Pustejovsky, J. E., & Rodgers, M. A. (2019).
#' Testing for funnel plot asymmetry of standardized mean differences.
#' \emph{Research Synthesis Methods}, 10(1), 57–71.
#' \doi{10.1002/jrsm.1332}
#'
#' What Works Clearinghouse (2021).
#' Supplement document for Appendix E and the What Works Clearinghouse procedures handbook, version 4.1
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf}
#'
#' @param N_cl_grp Numerical value indicating the sample size of the arm/group containing clustering.
#' @param N_ind_grp Numerical value indicating the sample size of the arm/group that does not contain clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#' @param ICC Numerical value indicating the (imputed) intra-class correlation.
#' @param g Numerical values indicating the estimated effect size (Hedges' g).
#' @param model Character indicating from what model the effect size estimate is
#' obtained. See details.
#' @param cluster_adj Logical indicating if clustering was adequately handled in model/study. Default is \code{FALSE}.
#' @param prepost_cor Numerical value indicating the pre-posttest correlation.
#' @param F_val Numerical value indicating the reported F statistics value. Note that \eqn{F = t^2}.
#' @param t_val Numerical value indicating the reported t statistics value.
#' @param SE Numerical value indicating the (reported) non-standardized standard error.
#' @param SD Numerical value indicating the pooled standard deviation.
#' @param SE_std Numerical value indicating the (reported) standardized standard error (SE).
#' @param R2 Numerical value indicating the (reported) \eqn{R^2} value from analysis model.
#' @param q Numerical value indicating the number of covariates.
#' @param add_name_to_vars Optional character string to be added to the variables names of the generated \code{tibble}.
#' @param vars Variables to be reported. Default is \code{NULL}. See Value section for further details.
#'
#'
#' @note Insert
#'
#' @return When \code{add_name_to_vars = NULL}, the function returns a \code{tibble} with the following variables:<br>
#' \item{gt}{The cluster and small sample adjusted effect size estimate.}
#' \item{vgt}{The cluster adjusted sampling variance estimate of \eqn{gt}.}
#' \item{Wgt}{The cluster adjusted samplingvariance estimate of \eqn{gt}, without the second term of the variance formula, as
#' given in Eq. (2) in Pustejovsky & Rodgers (2019).}
#' \item{hg}{The variance-stabilizing transformed effect size. See Eq. (3) in Pustejovsky & Rodgers (2019)}
#' \item{vhg}{The approximate sampling variance of hg}
#' \item{h}{The degrees of freedom given in Eq (7) in Hedges & Citkowicz (2015, p. 1298). See \code{\link{df_h_1armcluster}}.}
#' \item{df}{The degrees of freedom. If none or one covariate \eqn{df = h}.
#' otherwise with two or more covariates \eqn{df = h - q}.}
#' \item{n_covariates}{The number of covariates in the model, defined as \eqn{q} in Hedges et al. (2023).}
#' \item{var_term1}{Unadjusted measure of the first term of the variance formula.}
#' \item{adj_fct}{Indicating whether \eqn{\eta} or \eqn{\gamma} were used to adjust the variance. That is
#' whether the studies handle clustering inadequately or not.}
#' \item{adj_value}{Estimated value of adjustment factor.}
#'
#' @seealso \code{\link{df_h_1armcluster}}, \code{\link{eta_1armcluster}},
#' \code{\link{gamma_1armcluster}}
#'
#' @export
#'
#' @examples
#' vgt_smd_1armcluster(
#' N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.1, g = 0.2,
#' model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3
#' )
#'
#' # Example showing how to add a suffix to the variable names
#' vgt_smd_1armcluster(
#' N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.3, g = 0.2,
#' model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3, add_name_to_vars = "_icc03"
#' )
#'
#' # Example showing how to select specific variables
#' vgt_smd_1armcluster(
#' N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.3, g = 0.2,
#' model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3, add_name_to_vars = "_icc03",
#' vars = vgt_icc03
#' )
#'

vgt_smd_1armcluster <-
  function(
    N_cl_grp, N_ind_grp, avg_grp_size, ICC, g,
    model = c("posttest", "ANCOVA", "emmeans", "DiD", "reg_coef", "std_reg_coef"),
    cluster_adj = FALSE,
    prepost_cor = NULL, F_val = NULL, t_val = NULL, SE = NULL, SD = NULL, SE_std = NULL, R2 = NULL,
    q = 1,
    add_name_to_vars = NULL,
    vars = dplyr::everything()
  ){

  N1 <- N_cl_grp
  N2 <- N_ind_grp
  N <- N1 + N2
  n <- avg_grp_size
  rho <- ICC
  h <- df_h_1armcluster(N_total = N, ICC = rho, N_grp = N_cl_grp, avg_grp_size = avg_grp_size)


  if ("posttest" %in% model){


    if (is.numeric(t_val)){

      var_term1 <- g^2/t_val^2

    } else if (is.numeric(N_cl_grp) && is.numeric(N_ind_grp) && all(is.null(c(t_val, SE, SD)))){

      var_term1 <- (1/N1 + 1/N2)

    } else if (is.numeric(SE) && is.numeric(SD)){

      var_term1 <- (SE/SD)^2

    }

  }

  if (any(c("ANCOVA", "emmeans") %in% model)){

    if (is.numeric(t_val)){

      var_term1 <- g^2/t_val^2

    } else if (is.numeric(F_val)){

      var_term1 <- g^2/F_val

    } else if (is.numeric(R2)){

      var_term1 <- (1-R2) * (1/N1 + 1/N2)

    } else if (is.numeric(prepost_cor)){

      var_term1 <- (1-prepost_cor^2) * (1/N1 + 1/N2)

    }

    if (all(is.null(c(prepost_cor, F_val, t_val, SE, SD, SE_std, R2)))){

      stop(paste0("When specifying ANCOVA you must specify either the preposttest correlation",
                  "an F or t value, the standard error, or R2")
      )

    }

  }

  if ("DiD" %in% model){

    if (is.numeric(prepost_cor)){

      var_term1 <- 2*(1-prepost_cor) * (1/N1 + 1/N2)

    } else if (is.numeric(t_val)){

      var_term1 <- g^2/t_val^2

    } else if (is.numeric(F_val)){

      var_term1 <- g^2/F_val

    } else{

      stop(paste0("When calculating Diff-in-diffs effect sizes you must specify the preposttest correlation.",
           " If not known, impute r = 0.5. This amounts to calculating the sampling variance as for the posttest effect size"))

    }

  }

  if ("reg_coef" %in% model){

    if (all(is.null(c(SE, SD, t_val)))){
      stop("When model = 'reg_coef', you must specify both SE and SD, or t- or F-values.")
    }


    if (is.numeric(SE) && is.numeric(SD)){

      var_term1 <- (SE/SD)^2

    } else if (is.numeric(t_val)){

      var_term1 <- g^2/t_val^2

    } else if (is.numeric(F_val)){

      var_term1 <- g^2/F_val

    }

  }

  if ("std_reg_coef" %in% model) {

    if (is.null(SE_std)){
      stop("When model = 'std_reg_coef', you must specify SE_std.")
    }

    var_term1 <- SE_std^2

  }

  # Degrees of freedom calculation
  if (q > 1){
    df <- h - q
  } else {
    df <- h
  }

  if (!cluster_adj){

    adj_factor <- eta_1armcluster(N_total = N, Nc = N_ind_grp, avg_grp_size = avg_grp_size, ICC = rho)
    adj_name <- "eta"

    vgt <- var_term1 * adj_factor + g^2/(2*df)
    Wgt <- var_term1 * adj_factor

  } else {

    adj_factor <- gamma_1armcluster(N_total = N, Nc = N_ind_grp, avg_grp_size = avg_grp_size, ICC = rho, sqrt = FALSE)
    adj_name <- "gamma"

    vgt <- var_term1 * adj_factor + g^2/(2*df)
    Wgt <- var_term1 * adj_factor

  }


  res <- tibble::tibble(
    h = h,
    df = df,
    n_covariates = q,
    var_term1 = var_term1,
    adj_fct = adj_name,
    adj_value = adj_factor,
    gt = g,
    vgt = vgt,
    Wgt = Wgt,

    # Calculated from Equation (3) in Pustejovsky & Rodgers (2019, p. 60)
    a = sqrt(2*Wgt*df),
    hg = sqrt(2) * sign(g) * (log(abs(g) + sqrt(g^2 + a^2)) - log(a)),
    vhg = 1/df
  ) |>
  dplyr::select(-a) |>
  dplyr::relocate(gt:vhg)


  if (!is.null(add_name_to_vars)){

    if (!is.character(add_name_to_vars)){
      stop("add_name_to_vars only takes a character string as input")
    }

    res <- res |> dplyr::rename_with(~ paste0(.x, add_name_to_vars))

  }


  res |> dplyr::select({{vars}})

}
