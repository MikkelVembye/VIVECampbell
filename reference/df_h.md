# Degrees of freedom calculation for cluster bias correction for standardized mean differences

This function calculates the degrees of freedom for studies with
clustering, using Equation (E.21) from WWC (2022, p. 171). Can also be
found as h in WWC (2021). When `df_type = "Pustejovsky"`, the function
calculates the degrees of freedom, using the upsilon formula from
Pustejovsky (2016, find under the Cluster randomized trials section).
See further details below.

## Usage

``` r
df_h(N_total, ICC, avg_grp_size = NULL, n_clusters = NULL, df_type = "WWC")
```

## Arguments

- N_total:

  Numerical value indicating the total sample size of the study.

- ICC:

  Numerical value indicating the intra-class correlation (ICC) value.

- avg_grp_size:

  Numerical value indicating the average cluster size/ the average
  number of individuals per cluster.

- n_clusters:

  Numerical value indicating the number of clusters.

- df_type:

  Character indicating how the degrees of freedom are calculated.
  Default is `"WWC"`, which uses WWCs Equation E.21 (2022, p. 171).
  Alternative is `"Pustejovsky"`, which uses the upsilon formula from
  Pustejovsky (2016).

## Value

Returns a numerical value indicating the cluster adjusted degrees of
freedom.

## Details

When clustering is present the \\N-2\\ degrees of freedom (\\df\\) will
be a rather liberal choice, partly overestimating the small sample
corrector \\J\\ and partly underestimating the true variance of
(Hedges') \\g_T\\. The impact of the calculated \\df\\ will be most
consequential for small (sample) studies. To overcome these issues,
\\df\\ can instead be calculated in at least to different way. The What
Works Clearinghouse suggests using the following formula

\$\$ h = \dfrac{\[(N-2)-2(n-1)\rho\]^2} {(N-2)(1-\rho)^2 +
n(N-2n)\rho^2 + 2(N-2n)\rho(1-\rho)}\$\$

where \\N\\ is the total sample size, \\n\\ is average cluster size and
\\\rho\\ is the (imputed) intraclass correlation. Alternatively,
Pustejovsky (2016) suggests using the following formula to calculate
degrees of freedom cluster randomized trials

\$\$ \upsilon = \dfrac{n^2M(M-2)} {M\[(n-1)\rho^2 + 1\]^2 +
(M-2)(n-1)(1-\rho^2)^2}\$\$

where \\M\\ is the number of cluster which can also be calculated from
\\N/n\\.  

## Note

Read Taylor et al. (2020) to understand why we use the \\g_T\\ notation.
Find suggestions for how and which ICC values to impute when these are
unknown (Hedges & Hedberg, 2007, 2013).

## References

Hedges, L. V., & Hedberg, E. C. (2007). Intraclass correlation values
for planning group-randomized trials in education. *Educational
Evaluation and Policy Analysis*, 29(1), 60–87.
[doi:10.3102/0162373707299706](https://doi.org/10.3102/0162373707299706)

Hedges, L. V., & Hedberg, E. C. (2013). Intraclass correlations and
covariate outcome correlations for planning two- and three-Level
cluster-randomized experiments in education. *Evaluation Review*, 37(6),
445–489.
[doi:10.1177/0193841X14529126](https://doi.org/10.1177/0193841X14529126)

Pustejovsky (2016). Alternative formulas for the standardized mean
difference. <https://www.jepusto.com/alternative-formulas-for-the-smd/>

Taylor, J.A., Pigott, T.D., & Williams, R. (2020) Promoting knowledge
accumulation about intervention effects: Exploring strategies for
standardizing statistical approaches and effect size reporting.
*Educational Researcher*, 51(1), 72-80.
[doi:10.3102/0013189X211051319](https://doi.org/10.3102/0013189X211051319)

What Works Clearinghouse (2021). Supplement document for Appendix E and
the What Works Clearinghouse procedures handbook, version 4.1 *Institute
of Education Science*.
<https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf>

What Works Clearinghouse (2022). What Works Clearinghouse Procedures and
Standards Handbook, Version 5.0. *Institute of Education Science*.
<https://ies.ed.gov/ncee/wwc/Docs/referenceresources/Final_WWC-HandbookVer5_0-0-508.pdf>

## Examples

``` r
df_h(N_total = 100, ICC = 0.1, avg_grp_size = 5)
#> [1] 94.4

df_h(N_total = 100, ICC = 0.1, avg_grp_size = 5, df_type = "Pustejovsky")
#> [1] 92.29
```
