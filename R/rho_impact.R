
#' Conduct sensitivity analyses across various values of the assumed sample correlation
#' on the overall average effect in the CHE-RVE model
#'
#' @param data Data frame including relevant data for the function.
#' @param yi Vector of length k with the observed effect sizes/outcomes.
#' @param vi Sampling variance estimates of the observed effect sizes.
#' @param random Formula to specify the random-effects structure of the model. Default is "~ 1 | studyid / esid",
#' which amounts to fitting the correlated-hierarchical effects (CHE) model.
#' @param studyid Study ID specifying the cluster structure of the included studies.
#' @param r A numerical value or a vector specifying the assumed sampling correlation
#' between within-study effect size estimates. Default is seq(0, .9, .1).
#' @param smooth_vi Logical specifying whether to take the average \code{vi} within in each study.
#' Default is \code{TRUE}.
#'
#' @return a \code{tibble} of class \code{map_rho} with information about the estimated beta value, confidence and prediction intervals,
#' as well as variance components across specified values of the assumed sampling correlation.
#'
#' @importFrom stats as.formula
#' @export
#'
#' @examples
#' Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)
#'
#' map_rho_impact(
#'  data = head(Diet_dat, 100),
#'  yi = Effectsize_g,
#'  vi = vg,
#'  studyid = Study_ID
#')
#'

map_rho_impact <-
  function(data, yi, vi, studyid, r = seq(0, .9, .1), random = "~ 1 | studyid / esid", smooth_vi = TRUE){

  rho_impact <-
    function(data, yi, vi, cluster, r, random, smooth_vi){

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


  map_res <- purrr::map_dfr(r, ~ rho_impact(data = data,
                                 yi = {{ yi }},
                                 vi = {{ vi }},
                                 cluster = {{ studyid }},
                                 r = .x,
                                 random = random,
                                 smooth_vi = smooth_vi))


  tibble::new_tibble(map_res, class = "map_rho")


}


#' Plotting the impact of the assumed sampling correlation on the overall average effect size estimate
#'
#' @description Creates a plot showing the impact on the assumed sampling correlation (\eqn{\rho})
#' on the overall average effect size and the variance estimation.
#'
#' @details Inspiration to plot found from Pustejovsky and Tipton (2021).
#'
#' @references Pustejovsky, J. E., & Tipton, E. (2021).
#' Meta-analysis with robust variance estimation: Expanding the range of working models.
#' \emph{Prevention Science}, 23(1), 425–438.
#' \doi{10.1007/s11121-021-01246-3}
#'
#' @param data Data/object for which the plot should be made.
#' @param rho_used Numerical value indicating the (assumed) sampling correlation used
#' to fit the main CHE-RVE model.
#' @param prediction_interval Logical indicting whether a plot showing the impact of
#' the sampling correlation on the prediction interval estimation.
#' @param ylab_beta Optional character with the y-axis label for the overall mean effect plot
#' @param var_breaks Optional vector setting the y-axis breaks for the variance plot.
#'
#' @return A \code{ggplot} object
#'
#' @seealso \code{\link{map_rho_impact}}
#'
#' @examples
#' Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)
#'
#' map_rho_impact(
#'   data = head(Diet_dat, 100),
#'   yi = Effectsize_g,
#'   vi = vg,
#'   studyid = Study_ID
#' ) |>
#' plot_rho_impact(rho_used = 0.7, var_breaks = seq(0, 0.35, 0.05))
#'
#' @import patchwork
#' @export

plot_rho_impact <- function(data, rho_used, prediction_interval = FALSE, ylab_beta = NULL, var_breaks = NULL) UseMethod("plot_rho_impact")

#' @export

plot_rho_impact.default <-
  function(data, rho_used, prediction_interval = FALSE, ylab_beta = NULL, var_breaks = NULL){

    stop(paste0("plot_rho_impact does not know how to handle object of class ", class(data),
                ". It can only be used on objects of class 'map_rho'."))

  }

#' Plotting the impact of the assumed sampling correlation on the overall average effect size estimate
#'
#' @description Creates a plot showing the impact on the assumed sampling correlation (\eqn{\rho})
#' on the overall average effect size and the variance estimation.
#'
#' @details Inspiration to plot found from Pustejovsky and Tipton (2021).
#'
#' @references Pustejovsky, J. E., & Tipton, E. (2021).
#' Meta-analysis with robust variance estimation: Expanding the range of working models.
#' \emph{Prevention Science}, 23(1), 425–438.
#' \doi{10.1007/s11121-021-01246-3}
#'
#' @param data Data/object for which the plot should be made. Much be of class \code{map_rho}.
#' @param rho_used Numerical value indicating the (assumed) sampling correlation used
#' to fit the main CHE-RVE model.
#' @param prediction_interval Logical indicting whether a plot showing the impact of
#' the sampling correlation on the prediction interval estimation.
#' @param ylab_beta Optional character with the y-axis label for the overall mean effect plot.
#' @param var_breaks Optional vector setting the y-axis breaks for the variance plot.
#'
#' @return A \code{ggplot} object
#'
#' @seealso \code{\link{map_rho_impact}}
#'
#' @examples
#' Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)
#'
#' map_rho_impact(
#'   data = head(Diet_dat, 100),
#'   yi = Effectsize_g,
#'   vi = vg,
#'   studyid = Study_ID
#' ) |>
#' plot_rho_impact(rho_used = 0.7, var_breaks = seq(0, 0.35, 0.05))
#'
#' @import patchwork
#' @export

plot_rho_impact.map_rho <-
  function(data, rho_used, prediction_interval = FALSE, ylab_beta = NULL, var_breaks = NULL){

    if (prediction_interval){

      if (is.null(ylab_beta)) ylab_beta <- "Average effect size with prediction interval"

      rho_impact_beta_plot <-
        data |>
        dplyr::mutate(model = "CHE-RVE") |>
        ggplot2::ggplot(ggplot2::aes(x = rho, y = beta)) +
        ggplot2::geom_line(ggplot2::aes(color = model), size = 1) +
        ggplot2::geom_ribbon(ggplot2::aes(ymin = pi_l, ymax = pi_u,
                        fill = model), alpha = .2) +
        ggplot2::geom_hline(yintercept = 0) +
        ggplot2::geom_vline(xintercept = rho_used, linetype = "dashed") +
        ggplot2::scale_x_continuous(breaks = unique(data$rho)) +
        ggplot2::theme_light() +
        ggplot2::theme(
          strip.text = ggplot2::element_text(color = "black"),
          legend.position = "none"
        ) +
        ggplot2::facet_grid(~model) +
        ggplot2::scale_fill_manual(values = "cornflowerblue", name = "fill") +
        ggplot2::scale_color_manual(values = "cornflowerblue") +
        ggplot2::labs(y = ylab_beta,
             x = "")

    } else {

      if (is.null(ylab_beta)) ylab_beta <- "Average effect size with confidence interval"

      rho_impact_beta_plot <-
        data |>
        dplyr::mutate(model = "CHE-RVE") |>
        ggplot2::ggplot(ggplot2::aes(x = rho, y = beta)) +
        ggplot2::geom_line(ggplot2::aes(color = model), size = 1) +
        ggplot2::geom_ribbon(ggplot2::aes(ymin = ci_l, ymax = ci_u,
                        fill = model), alpha = .2) +
        ggplot2::geom_hline(yintercept = 0) +
        ggplot2::geom_vline(xintercept = rho_used, linetype = "dashed") +
        ggplot2::scale_x_continuous(breaks = unique(data$rho)) +
        ggplot2::theme_light() +
        ggplot2::theme(
          strip.text = ggplot2::element_text(color = "black"),
          legend.position = "none"
        ) +
        ggplot2::facet_grid(~model) +
        ggplot2::scale_fill_manual(values = "cornflowerblue", name = "fill") +
        ggplot2::scale_color_manual(values = "cornflowerblue") +
        ggplot2::labs(y = ylab_beta,
                      x = "")

    }

    if (prediction_interval) return(rho_impact_beta_plot)

    # True variance component plots

    var_dat <-
      data |>
      tidyr::pivot_longer(
        cols = omega:total_sd,
        names_to = "var"
      ) |>
      dplyr::arrange(var, rho) |>
      dplyr::mutate(
        var2 = base::rep(c("omega (within-study SD)", "tau (between-study SD)", "Total SD"), each = dplyr::n_distinct(rho)),
        var2 = factor(var2, levels = c("omega (within-study SD)", "tau (between-study SD)", "Total SD"))
      )


    rho_impact_sd_plot <-
      var_dat |>
      ggplot2::ggplot(ggplot2::aes(x = rho, y = value, color = var2)) +
      ggplot2::geom_line(size = 1) +
      ggplot2::scale_x_continuous(breaks = unique(var_dat$rho)) +
      ggplot2::scale_color_brewer(type = "qual", palette = 2, guide = "none") +
      ggplot2::geom_hline(yintercept = 0) +
      ggplot2::geom_vline(xintercept = rho_used, linetype = "dashed") +
      ggplot2::facet_grid(~var2) +
      ggplot2::theme_light() +
      ggplot2::theme(
        strip.text = ggplot2::element_text(color = "black"),
        #legend.position = "none"
      ) +
      ggplot2::labs(y = "Variance component",
           x = expression(Assumed~sampling~correlation~(rho)))

    if (!is.null(var_breaks)){

      rho_impact_sd_plot <-
        rho_impact_sd_plot +
        ggplot2::scale_y_continuous(breaks = var_breaks)

    }

    rho_impact_beta_plot / rho_impact_sd_plot

}

