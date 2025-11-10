# Calculate and cluster bias adjust odds ratios (OR)

This function calculated odds ratios based on various type of
input/information, as described in Table 11.10 from Borenstein and
Hedges (2019, p. 226).

## Usage

``` r
OR_calc(
  A = NULL,
  B = NULL,
  C = NULL,
  D = NULL,
  p1 = NULL,
  p2 = NULL,
  n1 = NULL,
  n2 = NULL,
  OR = NULL,
  LL_OR = NULL,
  UL_OR = NULL,
  SE_OR = NULL,
  V_OR = NULL,
  Z = 1.96,
  ICC = NULL,
  avg_cl_size = NULL,
  n_cluster_arms = 2,
  add_name_to_vars = NULL,
  vars = dplyr::everything()
)
```

## Arguments

- A:

  Upper left cell of an 2 X 2 frequency table.

- B:

  Upper right cell of an 2 X 2 frequency table.

- C:

  Lower left cell of an 2 X 2 frequency table.

- D:

  Lower right cell of an 2 X 2 frequency table.

- p1:

  Risk/probability of an event in group 1 (usually the treatment group).

- p2:

  Risk/probability of an event in group 2 (usually the control group).

- n1:

  Sample size of group 1 (usually the treatment group).

- n2:

  Sample size of group 2 (usually the control group).

- OR:

  Odds ratio estimate.

- LL_OR:

  Lower bound of the 95% confidence interval of the odds ratio.

- UL_OR:

  Upper bound of the 95% confidence interval of the odds ratio.

- SE_OR:

  Standard error of the odds ratio.

- V_OR:

  Sampling variance of the odds ratio.

- Z:

  Z-values from an normal distribution.

- ICC:

  Intra-class correlation.

- avg_cl_size:

  Average cluster size.

- n_cluster_arms:

  (Optional) Number of arm with clustering.

- add_name_to_vars:

  Optional character string to be added to the variables names of the
  generated `tibble`.

- vars:

  Variables to be reported. Default is `NULL`. See Value section for
  further details.

## Value

A `tibble` with information about OR, OR_LN, vln_OR.

## Details

2x2 table

|         |     |       |           |       |
|---------|-----|-------|-----------|-------|
|         |     | Event | Non-event | Total |
| Treated |     | A     | B         | n1    |
| Control |     | C     | D         | n2    |

## Note

Read Borenstein and Hedges (2019) for further details.

## References

Borenstein and Hedges (2019). Effect sizes for meta-analysis. In H.
Cooper, L. V. Hedges, & J. C. Valentine (Eds.), *The handbook of
research synthesis and meta-analysis* (3rd ed., pp. 207–242). Russell
Sage Foundation West Sussex.

Hedges, L. V., & Citkowicz, M (2015). Estimating effect size when there
is clustering in one treatment groups. *Behavior Research Methods*,
47(4), 1295-1308.
[doi:10.3758/s13428-014-0538-z](https://doi.org/10.3758/s13428-014-0538-z)

Higgins, J. P. T., Eldridge, S., & Li, T. (2019). In J. P. T. Higgins,
J. Thomas, J. Chandler, M. S. Cumpston, T. Li, M. Page, & V. Welch
(Eds.), *Cochrane handbook for systematic reviews of interventions* (2nd
ed., pp. 569–593). Wiley Online Library.
[doi:10.1002/9781119536604.ch23](https://doi.org/10.1002/9781119536604.ch23)

## Examples

``` r
# Using raw events
OR_calc(A = 20, B = 80, C = 10, D = 90)
#> # A tibble: 1 × 3
#>      OR ln_OR vln_OR
#>   <dbl> <dbl>  <dbl>
#> 1  2.25 0.811  0.174

# Using proportions
OR_calc(p1 = .2, p2 = .1, n1 = 100, n2 = 100)
#> # A tibble: 1 × 3
#>      OR ln_OR vln_OR
#>   <dbl> <dbl>  <dbl>
#> 1  2.25 0.811  0.174

# Using raw OR and CIs
OR_calc(OR = 2.25, LL_OR = 1.5, UL_OR = 3)
#> # A tibble: 1 × 3
#>      OR ln_OR vln_OR
#>   <dbl> <dbl>  <dbl>
#> 1  2.25 0.811 0.0313

# Adding suffix to variables and selecting specific variables
OR_calc(A = 20, B = 80, C = 10, D = 90, add_name_to_vars = "_test", vars = OR_test)
#> # A tibble: 1 × 1
#>   OR_test
#>     <dbl>
#> 1    2.25

# Cluster bias adjustment when there is clustering in both groups
OR_calc(p1 = .53, p2 = .11, n1 = 20, n2 = 26, ICC = 0.1, avg_cl_size = 8, n_cluster_arms = 2)
#> # A tibble: 1 × 5
#>      OR ln_OR vln_OR    DE vln_OR_C
#>   <dbl> <dbl>  <dbl> <dbl>    <dbl>
#> 1  9.12  2.21  0.594   1.7     1.01

# Cluster bias adjustment when there is clustering in one group only
OR_calc(p1 = .53, p2 = .11, n1 = 20, n2 = 26, ICC = 0.1, avg_cl_size = 8, n_cluster_arms = 1)
#> # A tibble: 1 × 5
#>      OR ln_OR vln_OR    DE vln_OR_C
#>   <dbl> <dbl>  <dbl> <dbl>    <dbl>
#> 1  9.12  2.21  0.594  1.35    0.803

```
