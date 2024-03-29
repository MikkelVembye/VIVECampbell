% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rho_impact.R
\name{map_rho_impact}
\alias{map_rho_impact}
\title{Conduct sensitivity analyses across various values of the assumed sample correlation
on the overall average effect in the CHE-RVE model}
\usage{
map_rho_impact(
  data,
  yi,
  vi,
  studyid,
  r = seq(0, 0.9, 0.1),
  random = "~ 1 | studyid / esid",
  smooth_vi = TRUE
)
}
\arguments{
\item{data}{Data frame including relevant data for the function.}

\item{yi}{Vector of length k with the observed effect sizes/outcomes.}

\item{vi}{Sampling variance estimates of the observed effect sizes.}

\item{studyid}{Study ID specifying the cluster structure of the included studies.}

\item{r}{A numerical value or a vector specifying the assumed sampling correlation
between within-study effect size estimates. Default is seq(0, .9, .1).}

\item{random}{Formula to specify the random-effects structure of the model. Default is "~ 1 | studyid / esid",
which amounts to fitting the correlated-hierarchical effects (CHE) model.}

\item{smooth_vi}{Logical specifying whether to take the average \code{vi} within in each study.
Default is \code{TRUE}.}
}
\value{
a \code{tibble} of class \code{map_rho} with information about the estimated beta value, confidence and prediction intervals,
as well as variance components across specified values of the assumed sampling correlation.
}
\description{
Conduct sensitivity analyses across various values of the assumed sample correlation
on the overall average effect in the CHE-RVE model
}
\examples{
Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)

map_rho_impact(
 data = head(Diet_dat, 100),
 yi = Effectsize_g,
 vi = vg,
 studyid = Study_ID
)

}
