#' Targeted school-based interventions data (K-6)
#'
#' Data from a meta-analysis of the effects of targeted school-based interventions
#' on reading and mathematics for students with or at risk of academic difficulties in Grades K-6
#' (Dietrichson et al., 2021)
#'
#'
#' @format A tibble with 1334 rows/studies and 71 variables/columns
#'
#' \tabular{lll}{
#'  \bold{Authors} \tab \code{character} \tab variable with short-hand information about authors. \cr
#'  \bold{Study_ID} \tab \code{integer} \tab Number identifying the study cluster. \cr
#'  \bold{Title}  \tab \code{character}   \tab Title of report/journal article. \cr
#'  \bold{Outlet} \tab \code{character}   \tab Variable with information about outlet for the study, i.e., either a journal or a dissertation or a report etc. \cr
#'  \bold{Country}    \tab \code{character}   \tab Variable with information about the country where the intervention was conducted. \cr
#'  \bold{Language}  \tab \code{character}   \tab Variable with information about the language used in the study. \cr
#'  \bold{Publishing_status}  \tab \code{character}   \tab Indicator equal to one if the study has been published in a journal. \cr
#'  \bold{RCT_QES}  \tab \code{character}   \tab Variable denoting whether the effect size is from a RCT or a QES \cr
#'  \bold{Level_treatment_assignment}  \tab \code{character}   \tab Variable indicating the level of treatment assignment. \cr
#'  \bold{Test_subject}  \tab \code{character}   \tab Variable denoting the subject of test the effect size is based on (reading or math). \cr
#'  \bold{Estimation_method}  \tab \code{character}   \tab Variable indicating the type of estimation method the effect
#'  estimate is taken from (e.g., raw means, adjusted means, regression adjusted). \cr
#'  \bold{Effectsize_g}  \tab \code{numeric}   \tab Effect size, Hedges' g, not adjusted for clustering. \cr
#'  \bold{SE_g}  \tab \code{numeric}   \tab The standard error of the effect size, not adjusted for clustering. \cr
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
#' @format A tibble with 548 rows/studies and 136 variables/columns
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



