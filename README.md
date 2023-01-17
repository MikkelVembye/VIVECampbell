
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VIVECampbell: Functions for Campbell reviews in VIVE

<!-- badges: start -->
<!-- badges: end -->

The package provides functions used in Campbell review conducted by
[VIVE - The Danish Center for Social Science
Research](https://www.vive.dk/en/). See also the VIVE Campbell
[homepage](https://www.vive.dk/da/centre-og-netvaerk/campbell/).

## Installation

You can install the development version of VIVECampbell like so:

``` r
# install.packages("devtools")
devtools::install_github("MikkelVembye/VIVECampbell")
```

``` r
# Load necessary packages
library(VIVECampbell)
library(dplyr)
```

## Example - Degrees of freedom calculation for cluster-designed studies

Calcualting degrees of freedom for studies with clustering in one
treatment group only (Hedges & Citkowicz, 2015)

``` r
## Degrees of freedom calculation for cluster bias correction when there is clustering in one treatment group only

h_eq7_hedges2015 <- 
  df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)

h_eq7_hedges2015
#> [1] 94.84
```

## Example - Data included in package

Data from the ‘Targeted school-based interventions for improving reading
and mathematics for students with or at risk of academic difficulties in
Grades K-6: A systematic review’ (Dietrichson et al., 2021)

``` r

# Data from a Campbell Systematic Review conducted by Dietrichson et al. (2021)
glimpse(Dietrichson2021_data[1:20])
#> Rows: 1,334
#> Columns: 20
#> $ Authors                    <chr> "Al-Hazza (2002)", "Al-Hazza (2002)", "Al-H…
#> $ Study_ID                   <chr> "19770510", "19770510", "19770510", "366227…
#> $ Title                      <chr> "An examination of the effects of the Ameri…
#> $ Year                       <dbl> 2002, 2002, 2002, 2005, 2005, 2005, 2005, 2…
#> $ Outlet                     <chr> "Dissertation", "Dissertation", "Dissertati…
#> $ Country                    <chr> "USA", "USA", "USA", "USA", "USA", "USA", "…
#> $ Language                   <chr> "English", "English", "English", "English",…
#> $ Publishing_status          <dbl> 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ RCT_QES                    <chr> "QES", "QES", "QES", "RCT", "RCT", "RCT", "…
#> $ Level_treatment_assignment <chr> "School", "School", "School", "Individual",…
#> $ Test_subject               <chr> "Reading", "Reading", "Reading", "Reading",…
#> $ Estimation_method          <chr> "adjusted means", "adjusted means", "adjust…
#> $ Effectsize_g               <dbl> 0.5534541, 0.3389140, 0.6929860, 0.5452505,…
#> $ SE_g                       <dbl> 0.3477837, 0.2969933, 0.3147417, 0.2910332,…
#> $ Effectsize_g_adj1          <dbl> 0.5415655, 0.3315552, 0.6779922, 0.5452505,…
#> $ SE_g_adj1                  <dbl> 0.4587296, 0.4127792, 0.4255886, 0.2910332,…
#> $ Effectsize_g_adj3          <dbl> 0.5127546, 0.3137140, 0.6416456, 0.5452505,…
#> $ SE_g_adj3                  <dbl> 0.6485337, 0.6022398, 0.6122611, 0.2910332,…
#> $ N_classrooms               <dbl> NA, NA, NA, 12, 12, 12, 12, 12, 12, 12, 12,…
#> $ N_schools                  <dbl> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4…

# Find documentation behind the data set by removing the below #
#?Dietrichson2021_data
```

# References

Dietrichson, J., Filges, T., Seerup, J. K., Klokker, R. H., Viinholt, B.
C. A., Bøg, M., & Eiberg, M. (2021). Targeted school-based interventions
for improving reading and mathematics for students with or at risk of
academic difficulties in Grades K-6: A systematic review. *Campbell
Systematic Reviews*, 17(2), e1152. <https://doi.org/10.1002/cl2.1152>

Hedges, L. V., & Citkowicz, M (2015). Estimating effect size when there
is clustering in one treatment groups. *Behavior Research Methods*,
47(4), 1295-1308. <https://doi.org/10.3758/s13428-014-0538-z>
