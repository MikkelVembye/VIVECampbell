
###################################################
# WWC and Pustejovsky calculation
###################################################

#' @title 'Degrees of freedom calculation for cluster bias correction for standardized mean differences'
#'
#' @description This function calculates the degrees of freedom for studies
#' with clustering, using Equation (E.21) from WWC (2022, p. 171). Can also be found
#' as h in WWC (2021). When \code{df_type = "Pustejovsky"}, the function calculates the
#' degrees of freedom, using the upsilon formula from Pustejovsky (2016). Find under
#' the Cluster randomized trials section.
#'
#' @references Pustejovsky (2016).
#' Alternative formulas for the standardized mean difference.
#' \url{https://www.jepusto.com/alternative-formulas-for-the-smd/}
#'
#' What Works Clearinghouse (2022).
#' What Works Clearinghouse Procedures and Standards Handbook, Version 5.0.
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/Final_WWC-HandbookVer5_0-0-508.pdf}
#'
#' What Works Clearinghouse (2021).
#' Supplement document for Appendix E and the What Works Clearinghouse procedures handbook, version 4.1
#' \emph{Institute of Education Science}.
#' \url{https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf}
#'
#' @template dfs-arg
#' @param df_type Character indicating how the degrees of freedom are calculated.
#' Default is \code{"WWC"}, which uses WWCs Equation E.21 (2022, p. 171). Alternative is \code{"Pustejovsky"},
#' which uses the upsilon formula from Pustejovsky (2016).
#'
#' @return Returns a numerical values indicating the cluster adjusted degrees of freedom.
#'
#' @export
#'
#' @examples
#' df_h(N_total = 100, ICC = 0.1, avg_grp_size = 5)

df_h <- function(N_total, ICC, avg_grp_size = NULL, n_clusters = NULL, df_type = "WWC"){

  if ("WWC" %in% df_type){

    if (length(N_total) == 1){
      N <- N_total
    } else {
      N <- sum(N_total)
    }

    rho <- ICC

    if (!is.null(avg_grp_size) & is.null(n_clusters)){

      n <- avg_grp_size

    } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

      n <- round(N/n_clusters)

    } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

      n <- avg_grp_size
      n_test <- round(N/n_clusters)

      if (n != n_test) {

        warning(paste0("The average cluster size diverges between the specified ",
                       "average group size and the N_total/n_clusters calculation"))
      }

    }

    h <- ((N-2) - 2 * (n-1) * rho)^2 /
      ((N-2) * (1-rho)^2 + n * (N-2*n) * rho^2 + 2*(N-2*n)*rho*(1-rho))

    df <- round(h, 2)

  }

  if ("Pustejovsky" %in% df_type){

    if (length(N_total) == 1){
      N <- N_total
    } else {
      N <- sum(N_total)
    }

    rho <- ICC

    if (!is.null(avg_grp_size) & is.null(n_clusters)){

      n <- avg_grp_size

    } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

      n <- round(N/n_clusters)

    } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

      n <- avg_grp_size
      n_test <- round(N/n_clusters)

      if (n != n_test) {

        warning(paste0("The average cluster size diverges between the specified ",
                       "average group size and the N_total/n_clusters calculation"))
      }

    }

    if (is.null(n_clusters)){

      M <- N/n

    } else {

      M <- n_clusters

    }

    upsilon <- (n^2*M * (M-2)) / (M*((n-1)*rho + 1)^2 + (M-2) * (n-1) * (1-rho)^2)

    df <- round(upsilon, 2)

  }

  df

}


###################################################
# One arm clustering calculation
###################################################


#' @title 'Degrees of freedom calculation for cluster bias correction when there is clustering in one treatment group only'
#'
#' @description This function calculates the degrees of freedom for studies
#' with clustering in one treatment group only, using Equation (7) from Hedges & Citkowicz (2015).
#'
#' @references Hedges, L. V., & Citkowicz, M (2015).
#' Estimating effect size when there is clustering in one treatment groups.
#' \emph{Behavior Research Methods}, 47(4), 1295-1308. \doi{10.3758/s13428-014-0538-z}
#'
#' @param N_total Numerical value indicating the total sample size of the study.
#' @param ICC Numerical value indicating the intra-class correlation (ICC) value.
#' @param N_grp Numerical value indicating the sample size of the arm/group containing clustering.
#' @param avg_grp_size Numerical value indicating the average cluster size.
#' @param n_clusters Numerical value indicating the number of clusters in the treatment group.
#'
#' @return Returns a numerical values indicating the cluster adjusted degrees of freedom.
#'
#' @export
#'
#' @examples
#' df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)


df_h_1armcluster <-
  function(N_total, ICC, N_grp, avg_grp_size = NULL, n_clusters = NULL){

  if (length(N_total) == 1){
    N <- N_total
  } else {
    N <- sum(N_total)
  }

  rho <- ICC
  NT <- N_grp

  if (!is.null(avg_grp_size) & is.null(n_clusters)){

    n <- avg_grp_size

  } else if (!is.null(n_clusters) & is.null(avg_grp_size)) {

    n <- round(N_grp/n_clusters)

  } else if (!is.null(avg_grp_size) & !is.null(n_clusters)){

    n <- avg_grp_size
    n_test <- round(N_grp/n_clusters)

    if (n != n_test) {

    warning(paste0("The average cluster size diverges between the specified ",
             "average group size and the N_total/n_clusters calculation"))
    }

  }

  h <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
    ((N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho)

  round(h, 2)

}




