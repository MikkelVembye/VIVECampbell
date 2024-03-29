% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rho_impact.R
\name{plot_rho_impact.map_rho}
\alias{plot_rho_impact.map_rho}
\title{Plotting the impact of the assumed sampling correlation on the overall average effect size estimate}
\usage{
\method{plot_rho_impact}{map_rho}(
  data,
  rho_used,
  prediction_interval = FALSE,
  ylab_beta = NULL,
  var_breaks = NULL
)
}
\arguments{
\item{data}{Data/object for which the plot should be made. Much be of class \code{map_rho}.}

\item{rho_used}{Numerical value indicating the (assumed) sampling correlation used
to fit the main CHE-RVE model.}

\item{prediction_interval}{Logical indicting whether a plot showing the impact of
the sampling correlation on the prediction interval estimation.}

\item{ylab_beta}{Optional character with the y-axis label for the overall mean effect plot.}

\item{var_breaks}{Optional vector setting the y-axis breaks for the variance plot.}
}
\value{
A \code{ggplot} object
}
\description{
Creates a plot showing the impact on the assumed sampling correlation (\eqn{\rho})
on the overall average effect size and the variance estimation.
}
\details{
Inspiration to plot found from Pustejovsky and Tipton (2021).
}
\examples{
Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)

map_rho_impact(
  data = head(Diet_dat, 100),
  yi = Effectsize_g,
  vi = vg,
  studyid = Study_ID
) |>
plot_rho_impact(rho_used = 0.7, var_breaks = seq(0, 0.35, 0.05))

}
\references{
Pustejovsky, J. E., & Tipton, E. (2021).
Meta-analysis with robust variance estimation: Expanding the range of working models.
\emph{Prevention Science}, 23(1), 425–438.
\doi{10.1007/s11121-021-01246-3}
}
\seealso{
\code{\link{map_rho_impact}}
}
