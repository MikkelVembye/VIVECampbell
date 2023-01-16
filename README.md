
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

## Example

Calcualting degrees of freedom for studies with clustering in one
treatment group only (Hedges & Citkowicz, 2015)

``` r
library(VIVECampbell)
## basic example code

df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)
#> [1] 94.84
```

# References

Hedges, L. V., & Citkowicz, M (2015). Estimating effect size when there
is clustering in one treatment groups. *Behavior Research Methods*,
47(4), 1295-1308. <https://doi.org/10.3758/s13428-014-0538-z>
