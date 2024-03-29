#' @title Small number of clusters correction when there is clustering in one treatment group only
#'
#' @description This function calculates a small cluster-design adjustment factor which can be used
#' to adjusted effect sizes (independently of how clustering is handled) and the sampling variances from cluster-design studies
#' that adequately handles clustering. This factor can be found in second term of Equation (5)
#' from from Hedges & Citkowicz (2015, p. 1298). The factor is denoted as \eqn{\gamma}{\gamma} in WWC (2021).
#' The same notion is used here and gave name to the function.
#'
#' @details When calculating effect sizes from cluster-designed studies, it recommended
#' (Hedges, 2007, 2011; Hedges & Citkowitz, 2015; WWC, 2021) to add an adjustment factor, \eqn{\gamma}{\gamma}
#' to \eqn{d}{d} whether or not cluster is adequately handled in the studies. Even if clustering
#' is adequately handled, WWC also recommend to use \eqn{\gamma}{\gamma} as a small number of clusters correction
#' to the variance component. The adjustment factor \eqn{\gamma} when there is clustering in one
#' treatment group only is given by
#'
#' \deqn{\gamma  = 1 - \dfrac{(N^C+n-2)\rho}{N-2}}
#'
#' where \eqn{N} is the total samples size, \eqn{N^C}{N-C} is the sample size of the group without clustering, \eqn{n}{n} is
#' the average cluster size, and \eqn{\rho}{\rho} is the (often imputed) intraclass correlation.
#'
#'  **Multiplying \eqn{\gamma} to posttest measures**<br>
#'
#' To illustrate this procedure, let the naive estimator of Hedges' \eqn{g}{g} be
#'
#' \deqn{g_{naive} = J\times \left(\dfrac{\bar{Y}^T_{\bullet\bullet} - \bar{Y}^C_{\bullet}}{S_T} \right)}
#'
#' where \eqn{J = 1 - 3/(4df-1)}, \eqn{\bar{Y}^T_{\bullet\bullet}} it the average treatment effect for the
#' treatment group containing clustering, \eqn{\bar{Y}^C_{\bullet}} is the average treatment effect
#' for the group without clustering, and \eqn{S_T} is the standard deviation ignoring clustering. To account for the
#' fact that \eqn{S_T} systematically underestimates the true standard deviation, \eqn{\sigma_T}, making \eqn{g} larger than the true
#' values of \eqn{g}, i.e., \eqn{\delta}, the cluster-adjusted effect size can be obtained from
#'
#' \deqn{g_T = g_{naive}\sqrt{\gamma}}
#'
#' if a study properly adjusted for clustering, the sampling variance of \eqn{g_T}
#' (when based on posttest measures only) is given by
#'
#' \deqn{v_{g_T} = \left(\dfrac{1}{N^T} + \dfrac{1}{N^C}\right) \gamma + \dfrac{g^2_T}{2h} }
#'
#' where \eqn{N^T} is the sample size of the treatment group containing clustering and \eqn{h} is
#' given by
#'
#' \deqn{ h = \dfrac{[(N-2)(1-\rho) + (N^T-n)\rho]^2}
#' {(N-2)(1-\rho)^2 + (N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}}
#'
#' where \eqn{N}{N} is the total sample size. See also \code{\link{df_h_1armcluster}}. \cr\cr
#'
#' The reason why we do not multiply \eqn{J^2} to \eqn{v_{g_T}}, as otherwise suggested by Borenstein et al. (2009, p. 27)
#' and Hedges & Citkowitz (2015, p. 1299), is that Hedges et al. (2023, p. 12) showed in a simulation that multiplying \eqn{J^2} to
#' \eqn{v_{g_T}} underestimates the true variance.
#'
#' **Multiplying \eqn{\gamma} to adjusted measures**<br>
#'
#' We do also use the small number of cluster adjustment factor \eqn{\gamma} for cluster adjustment
#' of variance estimates from pre-test and/or covariate adjusted measures.
#' See Table 1 below.
#'
#'  ***Table 1***<br>
#' *Sampling variance estimates for \eqn{g_T} across various models for handling cluster, estimation techniques, and reported quantities.*
#' | **Calculation type/<br>reported quantities**           | **Cluster-adjusted (model)<br>sampling variance**                                       | **Not cluster-adjusted (model)<br>sampling variance**                                  |
#' | --------------------                                   | ------------------                                                                      | -------------------                                                                    |
#' | ANCOVA, adj. means<br>\eqn{R^2, N^T, N^C}              | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}  |
#' | ANCOVA, adj. means<br>\eqn{R^2_{imputed}, N^T, N^C}    | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}  |
#' | ANCOVA, adj. means<br>\eqn{F, (t^2), N^T, N^C}         | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2(h-q)}.}                       | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2(h-q)}.}                      |
#' | ANCOVA, pretest only<br>\eqn{F, (t^2), N^T, N^C}       | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2h}.}                           | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2h}.}                            |
#' | ANCOVA, pretest only<br>\eqn{r, N^T, N^C}              | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}      |
#' | Reg coef<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2(h-q)}.}                      | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2(h-q)}.}                     |
#' | Reg coef, pretest only<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2h}.}            | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2h}.}                           |
#' | Std. reg coef<br>\eqn{SE_{std}, N^T, N^C}      | \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2(h-q)}.}                                                 | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2(h-q)}.}                                        |
#' | Std. reg coef, pretest only<br>\eqn{SE_{std}, N^T, N^C}      | \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2h}.}                                       | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2h}.}                                              |
#' | DiD, gain scores<br>\eqn{r, N^T, N^C}                  | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}      | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}       |
#' | DiD, gain scores<br>\eqn{r_{imputed}, N^T, N^C}        | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}      |
#' | DiD, gain scores<br>\eqn{t, N^T, N^C}                  | \eqn{\left(\frac{g^2}{t^2}\right) \gamma + \frac{g^2_T}{2h}.}      | \eqn{\left(\frac{g^2}{t^2}\right) \eta + \frac{g^2_T}{2h}.}       |
#'
#'
#' *Note*: \eqn{R^2} "is the multiple correlation between the covariates and the outcome" (WWC, 2021),
#' \eqn{\eta = 1 + [(nN^C/N)-1]\rho}, see \code{\link{eta_1armcluster}},
#' \eqn{r} is the pre-posttest correlation, and \eqn{q} is the number of covariates. Std. = standardized.
#'
#' "It is often desired in practice to adjust for multiple baseline characteristics.
#' The problem of \eqn{q} covariates is a straightforward extension of the single covariate case
#' (...): The correlation coefficient estimate \eqn{r} is now obtained by
#' taking the square root of the coefficient of multiple determination, \eqn{R^2}"
#' (Hedges et al. 2023, p. 17) and \eqn{df = h-q}.
#'
#'
#'**Multiplying \eqn{\gamma} to effect size difference-in-differences**<br>
#' Furthermore, \eqn{\gamma} can be used to correct effect size difference-in-differences as given
#' in Table 2
#'
#' ***Table 2***<br>
#' *Sampling variance estimates for effect size difference-in-differences*
#' | **Calculation type/<br>reported quantities**       | **Cluster-adjusted (model)<br>sampling variance**                                     | **Not cluster-adjusted (model)<br>sampling variance**                                    |
#' | --------------------                               | ------------------                                                                    | -------------------
#' | Effect size DiD<br>\eqn{r, N^T, N^C} | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.}| \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.} |
#' | Effect size DiD<br>\eqn{r_{imputed}, N^T, N^C} | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.}| \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.} |
#'
#'
#' @note Read Taylor et al. (2020) to understand why we use the \eqn{g_T}{g-T} notation.
#' Find suggestions for how and which ICC values to impute when these are unknown (Hedges & Hedberg, 2007, 2013).
#'
#' @references Borenstein, M., Hedges, L. V., Higgins, J. P. T., & Rothstein, H. R. (2009).
#' \emph{Introduction to meta-analysis} (1st ed.).
#' John Wiley & Sons.
#'
#' Hedges, L. V. (2007).
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
#' Hedges, L. V, Tipton, E., Zejnullahi, R., & Diaz, K. G. (2023).
#' Effect sizes in ANCOVA and difference-in-differences designs.
#' \emph{British Journal of Mathematical and Statistical Psychology}.
#' \doi{10.1111/bmsp.12296}
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
#' @param N_total Numerical value indicating the total sample size of the study.
#' @param Nc Numerical value indicating the sample size of the arm/group that does not contain clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#' @param ICC Numerical value indicating the intra-class correlation (ICC) value.
#' @param sqrt Logical indicating if the square root of gamma should be calculated. Default = \code{TRUE}
#'
#' @return Returns a numerical value for the cluster-design adjustment factor, \eqn{\gamma}.
#'
#' @seealso \code{\link{df_h_1armcluster}}, \code{\link{eta_1armcluster}}.
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

  gamma <- 1 - (Nc + n-2)*rho/(N-2)


  if (sqrt){
    res <- sqrt(gamma)
  } else {
    res <- gamma
  }

  round(res, 3)

}



#' @title Calculating the design effect to cluster bias adjusted sampling variances when there is clustering in one treatment group only
#'
#' @description The function calculates the design effect used to cluster bias adjust
#' sampling variance estimates that does not take into account clustering in one
#' treatment group. The design effect is given as the second term in Equation (6)
#' in Hedges & Citkowitz (2015, p. 6). The design effect is denoted as \eqn{\eta} in WWC (2021).
#' The same notion is used here and gave name to the function.
#'
#' @details  When calculating effect sizes from cluster-designed studies that do not
#' properly account for clustering in one treatment group, it recommended
#' (Hedges, 2007, 2011; Hedges & Citkowitz, 2015; WWC, 2021) to multiply a design effect, \eqn{\eta}
#' to the first term of the variance \eqn{g_T} that captures the contribution of the variance of
#' mean effect difference. The design effect when there is clustering in one
#' treatment group only is given by
#'
#' \deqn{\eta  = 1 + \left( \dfrac{nN^C}{N}-1 \right)\rho }
#'
#' where \eqn{N} is the total samples size, \eqn{N^C}{N-C} is the sample size of the group without clustering, \eqn{n}{n} is
#' the average cluster size, and \eqn{\rho}{\rho} is the (often imputed) intraclass correlation.
#'
#' **Multiplying the design effect to posttest measures**<br>
#'
#' To illustrate this procedure, let the naive estimator of Hedges' \eqn{g}{g} be
#'
#' \deqn{g_{naive} = J\times \left(\dfrac{\bar{Y}^T_{\bullet\bullet} - \bar{Y}^C_{\bullet}}{S_T} \right)}
#'
#' where \eqn{J = 1 - 3/(4df-1)}, \eqn{\bar{Y}^T_{\bullet\bullet}} it the average treatment effect for the
#' treatment group containing clustering, \eqn{\bar{Y}^C_{\bullet}} is the average treatment effect
#' for the group without clustering, and \eqn{S_T} is the standard deviation ignoring clustering. To account for the
#' fact that \eqn{S_T} systematically underestimates the true standard deviation, \eqn{\sigma_T}, making \eqn{g} larger than the true
#' values of \eqn{g}, i.e., \eqn{\delta}, the cluster-adjusted effect size can be obtained from
#'
#' \deqn{g_T = g_{naive}\sqrt{1 - \dfrac{(N^C+n-2)\rho}{N-2}}}
#'
#' if a study did not properly adjust for clustering, the sampling variance of \eqn{g_T}
#' (when based on posttest measures only) is given by
#'
#' \deqn{v_{g_T} = \left(\dfrac{1}{N^T} + \dfrac{1}{N^C}\right) \eta + \dfrac{g^2_T}{2h} }
#'
#' where \eqn{N^T} is the sample size of the treatment group containing clustering and \eqn{h} is
#' given by
#'
#' \deqn{ h = \dfrac{[(N-2)(1-\rho) + (N^T-n)\rho]^2}
#' {(N-2)(1-\rho)^2 + (N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}}
#'
#' where \eqn{N}{N} is the total sample size. See also \code{\link{df_h_1armcluster}}. \cr\cr
#'
#' The reason why we do not multiply \eqn{J^2} to \eqn{v_{g_T}}, as otherwise suggested by Borenstein et al. (2009, p. 27)
#' and Hedges & Citkowitz (2015, p. 1299), is that Hedges et al. (2023, p. 12) showed in a simulation that multiplying \eqn{J^2} to
#' \eqn{v_{g_T}} underestimates the true variance.
#'
#' **Multiplying the design effect to adjusted measures**<br>
#'
#' We do also use the design effect \eqn{\eta} for cluster-bias adjustment
#' of variance estimates from pre-test and/or covariate adjusted measures.
#' See Table 1 below.
#'
#' ***Table 1***<br>
#' *Sampling variance estimates for \eqn{g_T} across various models for handling cluster, estimation techniques, and reported quantities.*
#' | **Calculation type/<br>reported quantities**           | **Cluster-adjusted (model)<br>sampling variance**                                       | **Not cluster-adjusted (model)<br>sampling variance**                                  |
#' | --------------------                                   | ------------------                                                                      | -------------------                                                                    |
#' | ANCOVA, adj. means<br>\eqn{R^2, N^T, N^C}              | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-R^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}  |
#' | ANCOVA, adj. means<br>\eqn{R^2_{imputed}, N^T, N^C}    | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2(h-q)}.} | \eqn{(1-0^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2(h-q)}.}  |
#' | ANCOVA, adj. means<br>\eqn{F, (t^2), N^T, N^C}         | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2(h-q)}.}                       | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2(h-q)}.}                      |
#' | ANCOVA, pretest only<br>\eqn{F, (t^2), N^T, N^C}       | \eqn{\left(\frac{g^2_T}{F}\right) \gamma + \frac{g^2_T}{2h}.}                           | \eqn{\left(\frac{g^2_T}{F}\right) \eta + \frac{g^2_T}{2h}.}                            |
#' | ANCOVA, pretest only<br>\eqn{r, N^T, N^C}              | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{(1-r^2) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}      |
#' | Reg coef<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2(h-q)}.}                      | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2(h-q)}.}                     |
#' | Reg coef, pretest only<br>\eqn{SE, S_T, N^T, N^C}                    | \eqn{\left(\frac{SE}{S_T}\right)^2 \gamma + \frac{g^2_T}{2h}.}            | \eqn{\left(\frac{SE}{S_T}\right)^2 \eta + \frac{g^2_T}{2h}.}                           |
#' | Std. reg coef<br>\eqn{SE_{std}, N^T, N^C}      | \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2(h-q)}.}                                                 | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2(h-q)}.}                                        |
#' | Std. reg coef, pretest only<br>\eqn{SE_{std}, N^T, N^C}      | \eqn{SE^2_{std} \gamma + \frac{g^2_T}{2h}.}                                       | \eqn{SE^2_{std} \eta + \frac{g^2_T}{2h}.}                                              |
#' | DiD, gain scores<br>\eqn{r, N^T, N^C}                  | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}      | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}       |
#' | DiD, gain scores<br>\eqn{r_{imputed}, N^T, N^C}        | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_T}{2h}.}     | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_T}{2h}.}      |
#' | DiD, gain scores<br>\eqn{t, N^T, N^C}                  | \eqn{\left(\frac{g^2}{t^2}\right) \gamma + \frac{g^2_T}{2h}.}      | \eqn{\left(\frac{g^2}{t^2}\right) \eta + \frac{g^2_T}{2h}.}       |
#'
#'
#' *Note*: \eqn{R^2} "is the multiple correlation between the covariates and the outcome" (WWC, 2021),
#' \eqn{\gamma = 1 - (N^C+n-2)\rho/(N-2)}, see \code{\link{eta_1armcluster}},
#' \eqn{r} is the pre-posttest correlation, and \eqn{q} is the number of covariates. Std. = standardized.
#'
#' "It is often desired in practice to adjust for multiple baseline characteristics.
#' The problem of \eqn{q} covariates is a straightforward extension of the single covariate case
#' (...): The correlation coefficient estimate \eqn{r} is now obtained by
#' taking the square root of the coefficient of multiple determination, \eqn{R^2}"
#' (Hedges et al. 2023, p. 17) and \eqn{df = h-q}.
#'
#' **Multiplying the design effect to effect size difference-in-differences**<br>
#' Furthermore, \eqn{\eta} can be used to correct effect size difference-in-differences as given
#' in Table 2
#'
#' ***Table 2***<br>
#' *Sampling variance estimates for effect size difference-in-differences*
#' | **Calculation type/<br>reported quantities**       | **Cluster-adjusted (model)<br>sampling variance**                                     | **Not cluster-adjusted (model)<br>sampling variance**                                    |
#' | --------------------                               | ------------------                                                                    | -------------------
#' | Effect size DiD<br>\eqn{r, N^T, N^C} | \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.}| \eqn{2(1-r) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.} |
#' | Effect size DiD<br>\eqn{r_{imputed}, N^T, N^C} | \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \gamma + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.}| \eqn{2(1-.5) \left(\frac{1}{N^T} + \frac{1}{N^C}\right) \eta + \frac{g^2_{post} + g^2_{pre}r^2 - 2g_{pre}g_{post}r^2}{2h}.} |
#'
#' @note Read Taylor et al. (2020) to understand why we use the \eqn{g_T}{g-T} notation.
#' Find suggestions for how and which ICC values to impute when these are unknown (Hedges & Hedberg, 2007, 2013).
#'
#' @references Borenstein, M., Hedges, L. V., Higgins, J. P. T., & Rothstein, H. R. (2009).
#' \emph{Introduction to meta-analysis} (1st ed.).
#' John Wiley & Sons.
#'
#' Hedges, L. V. (2007).
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
#' Hedges, L. V, Tipton, E., Zejnullahi, R., & Diaz, K. G. (2023).
#' Effect sizes in ANCOVA and difference-in-differences designs.
#' \emph{British Journal of Mathematical and Statistical Psychology}.
#' \doi{10.1111/bmsp.12296}
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
#' @inheritParams gamma_1armcluster
#'
#' @return Returns a numerical value for the design effect \eqn{\eta} when there is clustering in one treatment group only.
#'
#' @seealso \code{\link{gamma_1armcluster}}, \code{\link{df_h_1armcluster}}
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
#' eta_1armcluster(N_total = N, Nc = Nc, avg_grp_size = n, ICC = rho)
#'
#' # Testing function
#' round(1 + (n*Nc/N - 1)*rho, 3)
#'

eta_1armcluster <- function(N_total, Nc, avg_grp_size, ICC, sqrt = FALSE){

  N <- N_total
  n <- avg_grp_size
  rho <- ICC

  eta <- 1 + (n*Nc/N - 1)*rho

  if (sqrt){
    res <- sqrt(eta)
  } else {
    res <- eta
  }

  round(res, 3)

}










