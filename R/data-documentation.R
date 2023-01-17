#' Targeted school-based interventions data (K-6)
#'
#' Data from a meta-analysis of the effects of targeted school-based interventions
#' on reading and mathematics for students with or at risk of academic difficulties in Grades K-6
#' (Dietrichson et al., 2021)
#'
#'
#' @format A tibble with 1334 rows/studies and 71 variables
#'
#' \describe{
#'  \item{Authors}{\code{String} variable with short-hand information about authors.}
#'  \item{Study_ID}{Number identifying the study cluster.}
#'  \item{Title}{Title of report/journal article.}
#'  \item{Outlet}{\code{String} variable with information about outlet for the study, i.e., either a journal or a dissertation or a report etc.}
#'  \item{Country}{\code{String} variable with information about the country where the intervention was conducted.}
#'  \item{Language}{\code{String} variable with information about the language used in the study.}
#'  \item{Publishing_status}{Indicator equal to one if the study has been published in a journal.}
#'  \item{RCT_QES}{\code{String} variable denoting whether the effect size is from a RCT or a QES}
#'  \item{Level_treatment_assignment}{\code{String} variable indicating the level of treatment assignment.}
#'  \item{Test_subject}{String variable denoting the subject of test the effect size is based on (reading or math).}
#'  \item{Estimation_method}{String variable indicating the type of estimation method the effect
#'  estimate is taken from (e.g., raw means, adjusted means, regression adjusted).}
#'  \item{Effectsize_g}{Effect size, Hedges' g, not adjusted for clustering.}
#'  \item{SE_g}{The standard error of the effect size, not adjusted for clustering.}
#'
#' }
#'
#'
#' @references Dietrichson, J., Filges, T., Seerup, J. K., Klokker, R. H.,
#' Viinholt, B. C. A., Bøg, M., & Eiberg, M. (2021).
#' Targeted school-based interventions for improving reading and mathematics for
#' students with or at risk of academic difficulties in Grades K-6: A systematic review.
#' \emph{Campbell Systematic Reviews}, 17(2), e1152. \doi{10.1002/cl2.1152}
#'


"Dietrichson2021_data"
