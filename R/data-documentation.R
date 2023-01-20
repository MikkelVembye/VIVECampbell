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


#' Fadeout data
#'
#' Data from four systematic reviews of school interventions implemented
#' in kindergarten to Grade 12 (Dietrichson et al., 2017, 2021; Dietrichson, Filges, et al., 2020;
#' Filges, Sonne-Schmidt, & Nielsen, 2018). The sample included in the data consist of a subset of 29 studies from
#' these reviews that included a post test and at least one follow-up test. Tests were
#' standardized tests of reading or mathematics. Most interventions were targeted (selected or
#' indicated) at students at risk of academic difficulties.
#'
#' @format A tibble with 548 rows/studies and 136 variables/colomns
#'
#' @seealso \code{\link{Dietrichson2021_data}}
#'
#' @references Dietrichson, J., Bøg, M., Filges, T., & Klint Jørgensen, A.-M. (2017).
#' Academic interventions for elementary and middle school students with low socioeconomic status:
#' A systematic review and meta-analysis. \emph{Review of Educational Research},
#' 87 (2), 243–282. \doi{10.3102/0034654316687036}
#'
#' Dietrichson, J., Filges, T., Klokker, R. H., Viinholt, B. C., Bøg, M., & Jensen, U. H. (2020).
#' Targeted school-based interventions for improving reading and mathematics for students with,
#' or at risk of, academic difficulties in grades 7–12: A systematic review.
#' \emph{Campbell Systematic Reviews}, 16(2). \doi{10.1002/cl2.1081}
#'
#' Dietrichson, J., Filges, T., Seerup, J. K., Klokker, R. H.,
#' Viinholt, B. C. A., Bøg, M., & Eiberg, M. (2021).
#' Targeted school-based interventions for improving reading and mathematics for
#' students with or at risk of academic difficulties in grades K-6: A systematic review.
#' \emph{Campbell Systematic Reviews}, 17(2), e1152. \doi{10.1002/cl2.1152}
#'
#' Filges, T., Sonne-Schmidt, C. S., & Nielsen, B. C. V. (2018).
#' Small class sizes for improving student achievement in primary and secondary schools:
#' A systematic review.
#' \emph{Campbell Systematic Reviews}, 14(1), 1-107. \doi{10.4073/csr.2018.10}
#'
#'

"fadeout"



#' Class size data
#'
#' Data from a systematic review on the effects of class size on student achievement in elementary school
#' (Filges, Sonne-Schmidt, & Nielsen, 2018).
#'
#'
#' @format A tibble with 8064 rows/studies and 27 variables/columns
#'
#'
#' @references Filges, T., Sonne-Schmidt, C. S., & Nielsen, B. C. V. (2018).
#' Small class sizes for improving student achievement in primary and secondary schools:
#' A systematic review.
#' \emph{Campbell Systematic Reviews}, 14(1), 1-107. \doi{10.4073/csr.2018.10}
#'
#'

"class_size"


