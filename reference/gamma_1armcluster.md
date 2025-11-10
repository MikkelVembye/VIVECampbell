# Small number of clusters correction when there is clustering in one treatment group only

This function calculates a small cluster-design adjustment factor which
can be used to adjusted effect sizes (independently of how clustering is
handled) and the sampling variances from cluster-design studies that
adequately handles clustering. This factor can be found in second term
of Equation (5) from from Hedges & Citkowicz (2015, p. 1298). The factor
is denoted as \\\gamma\\ in WWC (2021). The same notion is used here and
gave name to the function.

## Usage

``` r
gamma_1armcluster(N_total, Nc, avg_grp_size, ICC, sqrt = TRUE)
```

## Arguments

- N_total:

  Numerical value indicating the total sample size of the study.

- Nc:

  Numerical value indicating the sample size of the arm/group that does
  not contain clustering.

- avg_grp_size:

  Numerical value indicating the average cluster size.

- ICC:

  Numerical value indicating the intra-class correlation (ICC) value.

- sqrt:

  Logical indicating if the square root of \\\gamma\\ should be
  calculated. Default is `TRUE`.

## Value

Returns a numerical value for the cluster-design adjustment factor,
\\\gamma\\.

## Details

When calculating effect sizes from cluster-designed studies, it
recommended (Hedges, 2007, 2011; Hedges & Citkowitz, 2015; WWC, 2021) to
add an adjustment factor, \\\gamma\\ to \\d\\ whether or not cluster is
adequately handled in the studies. Even if clustering is adequately
handled, WWC also recommend to use \\\gamma\\ as a small number of
clusters correction to the variance component. The adjustment factor
\\\gamma\\ when there is clustering in one treatment group only is given
by

\$\$\gamma = 1 - \dfrac{(N^C+n-2)\rho}{N-2}\$\$

where \\N\\ is the total samples size, \\N^C\\ is the sample size of the
group without clustering, \\n\\ is the average cluster size, and
\\\rho\\ is the (often imputed) intraclass correlation.

**Multiplying \\\gamma\\ to posttest measures**  

To illustrate this procedure, let the naive estimator of Hedges' \\g\\
be

\$\$g\_{naive} = J\times \left(\dfrac{\bar{Y}^T\_{\bullet\bullet} -
\bar{Y}^C\_{\bullet}}{S_T} \right)\$\$

where \\J = 1 - 3/(4df-1)\\, \\\bar{Y}^T\_{\bullet\bullet}\\ it the
average treatment effect for the treatment group containing clustering,
\\\bar{Y}^C\_{\bullet}\\ is the average treatment effect for the group
without clustering, and \\S_T\\ is the standard deviation ignoring
clustering. To account for the fact that \\S_T\\ systematically
underestimates the true standard deviation, \\\sigma_T\\, making \\g\\
larger than the true values of \\g\\, i.e., \\\delta\\, the
cluster-adjusted effect size can be obtained from

\$\$g_T = g\_{naive}\sqrt{\gamma}\$\$

if a study properly adjusted for clustering, the sampling variance of
\\g_T\\ (when based on posttest measures only) is given by

\$\$v\_{g_T} = \left(\dfrac{1}{N^T} + \dfrac{1}{N^C}\right) \gamma +
\dfrac{g^2_T}{2h} \$\$

where \\N^T\\ is the sample size of the treatment group containing
clustering and \\h\\ is given by

\$\$ h = \dfrac{\[(N-2)(1-\rho) + (N^T-n)\rho\]^2} {(N-2)(1-\rho)^2 +
(N^T-n)n\rho^2 + 2(N^T-n)(1-\rho)\rho}\$\$

where \\N\\ is the total sample size. See also
[`df_h_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md).  
  

The reason why we do not multiply \\J^2\\ to \\v\_{g_T}\\, as otherwise
suggested by Borenstein et al. (2009, p. 27) and Hedges & Citkowitz
(2015, p. 1299), is that Hedges et al. (2023, p. 12) showed in a
simulation that multiplying \\J^2\\ to \\v\_{g_T}\\ underestimates the
true variance.

**Multiplying \\\gamma\\ to adjusted measures**  

We do also use the small number of cluster adjustment factor \\\gamma\\
for cluster adjustment of variance estimates from pre-test and/or
covariate adjusted measures. See Table 1 below.

***Table 1***  
*Sampling variance estimates for \\g_T\\ across various models for
handling cluster, estimation techniques, and reported quantities.*

[TABLE]

*Note*: \\R^2\\ "is the multiple correlation between the covariates and
the outcome" (WWC, 2021), \\\eta = 1 + \[(nN^C/N)-1\]\rho\\, see
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md),
\\r\\ is the pre-posttest correlation, and \\q\\ is the number of
covariates. Std. = standardized.

"It is often desired in practice to adjust for multiple baseline
characteristics. The problem of \\q\\ covariates is a straightforward
extension of the single covariate case (...): The correlation
coefficient estimate \\r\\ is now obtained by taking the square root of
the coefficient of multiple determination, \\R^2\\" (Hedges et al. 2023,
p. 17) and \\df = h-q\\.

**Multiplying \\\gamma\\ to effect size difference-in-differences**  
Furthermore, \\\gamma\\ can be used to correct effect size
difference-in-differences as given in Table 2

***Table 2***  
*Sampling variance estimates for effect size difference-in-differences*

[TABLE]

## Note

Read Taylor et al. (2020) to understand why we use the \\g_T\\ notation.
Find suggestions for how and which ICC values to impute when these are
unknown (Hedges & Hedberg, 2007, 2013).

## References

Borenstein, M., Hedges, L. V., Higgins, J. P. T., & Rothstein, H. R.
(2009). *Introduction to meta-analysis* (1st ed.). John Wiley & Sons.

Hedges, L. V. (2007). Effect sizes in cluster-randomized designs.
*Journal of Educational and Behavioral Statistics*, 32(4), 341–370.
[doi:10.3102/1076998606298043](https://doi.org/10.3102/1076998606298043)

Hedges, L. V. (2011). Effect sizes in three-level cluster-randomized
experiments. *Journal of Educational and Behavioral Statistics*, 36(3),
346–380.
[doi:10.3102/1076998610376617](https://doi.org/10.3102/1076998610376617)

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

Hedges, L. V, Tipton, E., Zejnullahi, R., & Diaz, K. G. (2023). Effect
sizes in ANCOVA and difference-in-differences designs. *British Journal
of Mathematical and Statistical Psychology*.
[doi:10.1111/bmsp.12296](https://doi.org/10.1111/bmsp.12296)

Taylor, J.A., Pigott, T.D., & Williams, R. (2020) Promoting knowledge
accumulation about intervention effects: Exploring strategies for
standardizing statistical approaches and effect size reporting.
*Educational Researcher*, 51(1), 72-80.
[doi:10.3102/0013189X211051319](https://doi.org/10.3102/0013189X211051319)

What Works Clearinghouse (2021). Supplement document for Appendix E and
the What Works Clearinghouse procedures handbook, version 4.1 *Institute
of Education Science*.
<https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf>

## See also

[`df_h_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md),
[`eta_1armcluster`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md).

## Examples

``` r
N <- 100
Nc <- 40
n <- 5
rho <- 0.1

gamma_1armcluster(N_total = N, Nc = Nc, avg_grp_size = n, ICC = rho)
#> [1] 0.978

# Testing function
sqrt(1 - (((Nc + n-2)*rho)/(N-2))) |> round(3)
#> [1] 0.978
```
