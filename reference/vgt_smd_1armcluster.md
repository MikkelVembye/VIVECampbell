# Variance calculation when there is clustering in one treatment group only

This function calculates the sampling variance estimates for effect
sizes obtained from cluster-designed studies. This include measures of
the sampling variance, a modified variance estimate for publication bias
testing, and a variance-stabilized transformed effect size and variance
as presented in Pustejovsky & Rodgers (2019).

## Usage

``` r
vgt_smd_1armcluster(
  N_cl_grp,
  N_ind_grp,
  avg_grp_size,
  ICC,
  g,
  model = c("posttest", "ANCOVA", "emmeans", "DiD", "reg_coef", "std_reg_coef"),
  cluster_adj = FALSE,
  prepost_cor = NULL,
  F_val = NULL,
  t_val = NULL,
  SE = NULL,
  SD = NULL,
  SE_std = NULL,
  R2 = NULL,
  q = 1,
  add_name_to_vars = NULL,
  vars = dplyr::everything()
)
```

## Arguments

- N_cl_grp:

  Numerical value indicating the sample size of the arm/group containing
  clustering.

- N_ind_grp:

  Numerical value indicating the sample size of the arm/group that does
  not contain clustering.

- avg_grp_size:

  Numerical value indicating the average cluster size.

- ICC:

  Numerical value indicating the (imputed) intra-class correlation.

- g:

  Numerical values indicating the estimated effect size (Hedges' g).

- model:

  Character indicating from what model the effect size estimate is
  obtained. See details.

- cluster_adj:

  Logical indicating if clustering was adequately handled in
  model/study. Default is `FALSE`.

- prepost_cor:

  Numerical value indicating the pre-posttest correlation.

- F_val:

  Numerical value indicating the reported F statistics value. Note that
  \\F = t^2\\.

- t_val:

  Numerical value indicating the reported t statistics value.

- SE:

  Numerical value indicating the (reported) non-standardized standard
  error.

- SD:

  Numerical value indicating the pooled standard deviation.

- SE_std:

  Numerical value indicating the (reported) standardized standard error
  (SE).

- R2:

  Numerical value indicating the (reported) \\R^2\\ value from analysis
  model.

- q:

  Numerical value indicating the number of covariates.

- add_name_to_vars:

  Optional character string to be added to the variables names of the
  generated `tibble`.

- vars:

  Variables to be reported. Default is `NULL`. See Value section for
  further details.

## Value

When `add_name_to_vars = NULL`, the function returns a `tibble` with the
following variables:  

- gt:

  The cluster and small sample adjusted effect size estimate.

- vgt:

  The cluster adjusted sampling variance estimate of \\gt\\.

- Wgt:

  The cluster adjusted samplingvariance estimate of \\gt\\, without the
  second term of the variance formula, as given in Eq. (2) in
  Pustejovsky & Rodgers (2019).

- hg:

  The variance-stabilizing transformed effect size. See Eq. (3) in
  Pustejovsky & Rodgers (2019)

- vhg:

  The approximate sampling variance of hg

- h:

  The degrees of freedom given in Eq (7) in Hedges & Citkowicz (2015, p.
  1298). See
  [`df_h_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md).

- df:

  The degrees of freedom. If none or one covariate \\df = h\\. otherwise
  with two or more covariates \\df = h - q\\.

- n_covariates:

  The number of covariates in the model, defined as \\q\\ in Hedges et
  al. (2023).

- var_term1:

  Unadjusted measure of the first term of the variance formula.

- adj_fct:

  Indicating whether \\\eta\\ or \\\gamma\\ were used to adjust the
  variance. That is whether the studies handle clustering inadequately
  or not.

- adj_value:

  Estimated value of adjustment factor.

## Details

Table 1 illustrates all cluster adjustment of variance estimates from
pre-test and/or covariate-adjusted measures that can be calculated with
the vgt_smd_1armcluster()

***Table 1***  
*Sampling variance estimates for \\g_T\\ across various models for
handling cluster, estimation techniques, and reported quantities.*

[TABLE]

*Note*: \\R^2\\ "is the multiple correlation between the covariates and
the outcome" (WWC, 2021), \\\eta = 1 - (N^C+n-2)\rho/(N-2)\\, see
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
\\\gamma = 1 - (N^C+n-2)\rho/(N-2)\\, see
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
\\r\\ is the pre-posttest correlation, and \\q\\ is the number of
covariates. Std. = standardized.

"It is often desired in practice to adjust for multiple baseline
characteristics. The problem of \\q\\ covariates is a straightforward
extension of the single covariate case (...): The correlation
coefficient estimate \\r\\ is now obtained by taking the square root of
the coefficient of multiple determination, \\R^2\\" (Hedges et al. 2023,
p. 17) and \\df = h-q\\.

**Calculating modified measures of variance for publication bias
testing**

***Table 2***  
*Sampling variance estimates for \\g_T\\ across various models for
handling cluster, estimation techniques, and reported quantities.*

[TABLE]

*Note*: \\R^2\\ "is the multiple correlation between the covariates and
the outcome" (WWC, 2021), \\\eta = 1 - (N^C+n-2)\rho/(N-2)\\, see
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
\\\gamma = 1 - (N^C+n-2)\rho/(N-2)\\, see
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
and \\r\\ is the pre-posttest correlation. Std. = standardized.

"It is often desired in practice to adjust for multiple baseline
characteristics. The problem of \\q\\ covariates is a straightforward
extension of the single covariate case (...): The correlation
coefficient estimate \\r\\ is now obtained by taking the square root of
the coefficient of multiple determination, \\R^2\\" (Hedges et al. 2023,
p. 17) and \\df = h-q\\.

## Note

Insert

## References

Hedges, L. V., & Citkowicz, M (2015). Estimating effect size when there
is clustering in one treatment groups. *Behavior Research Methods*,
47(4), 1295-1308.
[doi:10.3758/s13428-014-0538-z](https://doi.org/10.3758/s13428-014-0538-z)

Pustejovsky, J. E., & Rodgers, M. A. (2019). Testing for funnel plot
asymmetry of standardized mean differences. *Research Synthesis
Methods*, 10(1), 57–71.
[doi:10.1002/jrsm.1332](https://doi.org/10.1002/jrsm.1332)

What Works Clearinghouse (2021). Supplement document for Appendix E and
the What Works Clearinghouse procedures handbook, version 4.1 *Institute
of Education Science*.
<https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf>

## See also

[`df_h_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md),
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
[`gamma_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/gamma_1armcluster.md)

## Examples

``` r
vgt_smd_1armcluster(
N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.1, g = 0.2,
model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3
)
#> # A tibble: 1 × 11
#>      gt    vgt    Wgt    hg    vhg     h    df n_covariates var_term1 adj_fct
#>   <dbl>  <dbl>  <dbl> <dbl>  <dbl> <dbl> <dbl>        <dbl>     <dbl> <chr>  
#> 1   0.2 0.0273 0.0271 0.128 0.0111  93.0  90.0            3    0.0208 eta    
#> # ℹ 1 more variable: adj_value <dbl>

# Example showing how to add a suffix to the variable names
vgt_smd_1armcluster(
N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.3, g = 0.2,
model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3, add_name_to_vars = "_icc03"
)
#> # A tibble: 1 × 11
#>   gt_icc03 vgt_icc03 Wgt_icc03 hg_icc03 vhg_icc03 h_icc03 df_icc03
#>      <dbl>     <dbl>     <dbl>    <dbl>     <dbl>   <dbl>    <dbl>
#> 1      0.2    0.0399    0.0396    0.131    0.0172    61.3     58.3
#> # ℹ 4 more variables: n_covariates_icc03 <dbl>, var_term1_icc03 <dbl>,
#> #   adj_fct_icc03 <chr>, adj_value_icc03 <dbl>

# Example showing how to select specific variables
vgt_smd_1armcluster(
N_cl_grp = 60, N_ind_grp = 40, avg_grp_size = 10, ICC = 0.3, g = 0.2,
model = "ANCOVA", cluster_adj = FALSE, R2 = 0.5, q = 3, add_name_to_vars = "_icc03",
vars = vgt_icc03
)
#> # A tibble: 1 × 1
#>   vgt_icc03
#>       <dbl>
#> 1    0.0399
```
