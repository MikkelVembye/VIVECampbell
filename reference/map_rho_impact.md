# Conduct sensitivity analyses across various values of the assumed sample correlation on the overall average effect in the CHE-RVE model

Conduct sensitivity analyses across various values of the assumed sample
correlation on the overall average effect in the CHE-RVE model

## Usage

``` r
map_rho_impact(
  data,
  yi,
  vi,
  studyid,
  r = seq(0, 0.9, 0.1),
  random = "~ 1 | studyid / esid",
  smooth_vi = TRUE
)
```

## Arguments

- data:

  Data frame including relevant data for the function.

- yi:

  Vector of length k with the observed effect sizes/outcomes.

- vi:

  Sampling variance estimates of the observed effect sizes.

- studyid:

  Study ID specifying the cluster structure of the included studies.

- r:

  A numerical value or a vector specifying the assumed sampling
  correlation between within-study effect size estimates. Default is
  seq(0, .9, .1).

- random:

  Formula to specify the random-effects structure of the model. Default
  is "~ 1 \| studyid / esid", which amounts to fitting the
  correlated-hierarchical effects (CHE) model.

- smooth_vi:

  Logical specifying whether to take the average `vi` within in each
  study. Default is `TRUE`.

## Value

a `tibble` of class `map_rho` with information about the estimated beta
value, confidence and prediction intervals, as well as variance
components across specified values of the assumed sampling correlation.

## Examples

``` r
Diet_dat <- Dietrichson2021_data |> dplyr::mutate(vg = SE_g^2)

map_rho_impact(
 data = head(Diet_dat, 100),
 yi = Effectsize_g,
 vi = vg,
 studyid = Study_ID
)
#> # A tibble: 10 × 11
#>     beta   se_b   ci_l  ci_u   pi_l  pi_u     omega   tau total_sd   rho avg_var
#>    <dbl>  <dbl>  <dbl> <dbl>  <dbl> <dbl>     <dbl> <dbl>    <dbl> <dbl> <lgl>  
#>  1 0.237 0.0741 0.0816 0.393 -0.415 0.889   7.58e-6 0.301    0.301   0   TRUE   
#>  2 0.234 0.0736 0.0798 0.389 -0.411 0.879   7.16e-2 0.289    0.298   0.1 TRUE   
#>  3 0.232 0.0731 0.0784 0.385 -0.409 0.873   1.07e-1 0.276    0.296   0.2 TRUE   
#>  4 0.229 0.0726 0.0768 0.382 -0.408 0.866   1.31e-1 0.263    0.294   0.3 TRUE   
#>  5 0.227 0.0721 0.0752 0.378 -0.406 0.860   1.51e-1 0.250    0.292   0.4 TRUE   
#>  6 0.224 0.0716 0.0736 0.375 -0.406 0.854   1.69e-1 0.236    0.291   0.5 TRUE   
#>  7 0.222 0.0712 0.0721 0.372 -0.405 0.849   1.86e-1 0.222    0.289   0.6 TRUE   
#>  8 0.220 0.0707 0.0705 0.369 -0.406 0.845   2.01e-1 0.207    0.288   0.7 TRUE   
#>  9 0.217 0.0703 0.0690 0.366 -0.407 0.842   2.16e-1 0.190    0.288   0.8 TRUE   
#> 10 0.215 0.0699 0.0676 0.363 -0.410 0.840   2.30e-1 0.173    0.287   0.9 TRUE   
```
