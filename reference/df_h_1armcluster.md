# Degrees of freedom calculation for cluster bias correction when there is clustering in one treatment group only

This function calculates the degrees of freedom for studies with
clustering in one treatment group only, using Equation (7) from Hedges &
Citkowicz (2015).

## Usage

``` r
df_h_1armcluster(N_total, ICC, N_grp, avg_grp_size = NULL, n_clusters = NULL)
```

## Arguments

- N_total:

  Numerical value indicating the total sample size of the study.

- ICC:

  Numerical value indicating the intra-class correlation (ICC) value.

- N_grp:

  Numerical value indicating the sample size of the arm/group containing
  clustering.

- avg_grp_size:

  Numerical value indicating the average cluster size.

- n_clusters:

  Numerical value indicating the number of clusters in the treatment
  group.

## Value

Returns a numerical value indicating the cluster adjusted degrees of
freedom.

## Details

When clustering is present the \\N-2\\ degrees of freedom (\\df\\) will
be a rather liberal choice, partly overestimating the small sample
corrector \\J\\ and partly underestimating the true variance of
(Hedges') \\g_T\\. The impact of the calculated \\df\\ will be most
consequential for small (sample) studies. To overcome these issues,
Hedges & Citkowicz (2015) suggest obtaining the degrees of freedom from

\$\$ h = \dfrac{\[(N-2)(1-\rho) + (N^T-n)\rho\]^2} {(N-2)(1-\rho)^2 +
(N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}\$\$

where \\N\\ is the total sample size, \\N^T\\ is the sample size of the
treatment group, containg clustering, \\n\\ is average cluster size and
\\\rho\\ is the (imputed) intraclass correlation.

## Note

Read Taylor et al. (2020) to understand why we use the \\g_T\\ notation.
Find suggestions for how and which ICC values to impute when these are
unknown (Hedges & Hedberg, 2007, 2013).

## References

Hedges, L. V., & Citkowicz, M (2015). Estimating effect size when there
is clustering in one treatment groups. *Behavior Research Methods*,
47(4), 1295-1308.
[doi:10.3758/s13428-014-0538-z](https://doi.org/10.3758/s13428-014-0538-z)

Hedges, L. V., & Hedberg, E. C. (2007). Intraclass correlation values
for planning group-randomized trials in education. *Educational
Evaluation and Policy Analysis*, 29(1), 60–87.
[doi:10.3102/0162373707299706](https://doi.org/10.3102/0162373707299706)

Hedges, L. V., & Hedberg, E. C. (2013). Intraclass correlations and
covariate outcome correlations for planning two- and three-Level
cluster-randomized experiments in education. *Evaluation Review*, 37(6),
445–489.
[doi:10.1177/0193841X14529126](https://doi.org/10.1177/0193841X14529126)

Taylor, J.A., Pigott, T.D., & Williams, R. (2020) Promoting knowledge
accumulation about intervention effects: Exploring strategies for
standardizing statistical approaches and effect size reporting.
*Educational Researcher*, 51(1), 72-80.
[doi:10.3102/0013189X211051319](https://doi.org/10.3102/0013189X211051319)

## Examples

``` r
df <- df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)
df
#> [1] 95.4


# Testing function
N <- 100
rho <- 0.1
NT <- 60
n <- 5

df_raw <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
          ( (N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho )

round(df_raw, 2)
#> [1] 95.4

```
