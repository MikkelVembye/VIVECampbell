
#' Generate the impact of the assumed sample correlation on the overall average effect in the CHE-RVE model
#'
#' @param data data frame including relevant data for the function
#' @param yi vector of length k with the observed effect sizes/outcomes
#' @param vi sampling variance estimates of the observed effect sizes
#' @param random formula to specify the random-effects structure of the model. Default is "~ 1 | studyid / esid",
#' which amounts to fitting the correlated-hierarchical effects (CHE) model.
#' @param studyid study ID specifying the cluster structure of the included studies
#' @param r numerical value specifying the assumed sampling correlation between within-study effect size estimates.
#' @param smooth_vi logical specifying whether to take the average \code{vi} within in each study.
#' Default is \code{TRUE}
#'
#' @return a \code{tibble} with information about the estimated beta value, confidence and prediction intervals,
#' as well as variance components across specified values of the assumed sampling correlation.
#'
#' @importFrom stats as.formula
#' @export
#'
#' @examples
#' Diet_dat <- Dietrichson2021_data |>
#'  dplyr::mutate(
#'    vg = SE_g^2,
#'    studyid = as.numeric(Study_ID),
#'    esid = 1:nrow(Dietrichson2021_data)
#'  ) |>
#'  dplyr::mutate(
#'    vg_avg = mean(vg),
#'    .by = studyid
#'  )
#'
#' map_rho_impact(
#'  data = head(Diet_dat, 100),
#'  yi = Effectsize_g,
#'  vi = vg,
#'  studyid = Study_ID,
#'  r = seq(0, .9, .1)
#')
#'

map_rho_impact <-
  function(data, yi, vi, random = "~ 1 | studyid / esid", studyid, r, smooth_vi = TRUE){

  rho_impact <-
    function(data, yi, vi, random, cluster, r, smooth_vi){

      data <-
        data |>
        dplyr::mutate(
          yi = {{ yi }},
          vi = {{ vi }},
          studyid = as.numeric({{ cluster }}),
          esid = 1:nrow(data)
        )

      if (smooth_vi){

        dat <- data |> dplyr::mutate(vg_avg = mean(vi), .by = studyid)
        V <- metafor::vcalc(vg_avg, cluster = studyid, obs = esid, data = dat, rho = r)

      } else {

        dat <- data
        V <- metafor::vcalc(vi, cluster = studyid, obs = esid, data = dat, rho = r)

      }

      overall_RVE <-
        metafor::rma.mv(
          yi ~ 1,
          V = V,
          random = as.formula(random),
          data = dat
        ) |>
        metafor::robust(cluster = studyid, clubSandwich = TRUE)

      pred_res <- metafor::predict.rma(overall_RVE)

      res <-
        tibble::tibble(
          beta = as.numeric(overall_RVE$beta),
          se_b = as.numeric(overall_RVE$se),
          ci_l = overall_RVE$ci.lb,
          ci_u = overall_RVE$ci.ub,
          pi_l = pred_res$pi.lb,
          pi_u = pred_res$pi.ub,
          omega = sqrt(overall_RVE$sigma2[2]),
          tau = sqrt(overall_RVE$sigma2[1]),
          total_sd = sqrt(sum(overall_RVE$sigma2)),
          rho = r,
          avg_var = smooth_vi
        )

      res

  }


  purrr::map_dfr(r, ~ rho_impact(data = data,
                                 yi = {{ yi }},
                                 vi = {{ vi }},
                                 random = random,
                                 cluster = {{ studyid }},
                                 r = .x,
                                 smooth_vi = smooth_vi))

}



