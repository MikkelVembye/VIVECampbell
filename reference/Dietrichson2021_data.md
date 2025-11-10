# Targeted school-based interventions data (K-6)

Data from a meta-analysis of the effects of targeted school-based
interventions on reading and mathematics for students with or at risk of
academic difficulties in Grades K-6 (Dietrichson et al., 2021)

## Usage

``` r
Dietrichson2021_data
```

## Format

A tibble with 1334 rows/studies and 71 variables/columns

|                                |             |                                                                                                                                             |
|--------------------------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| **Authors**                    | `character` | variable with short-hand information about authors.                                                                                         |
| **Study_ID**                   | `integer`   | Number identifying the study cluster.                                                                                                       |
| **Title**                      | `character` | Title of report/journal article.                                                                                                            |
| **Outlet**                     | `character` | Variable with information about outlet for the study, i.e., either a journal or a dissertation or a report etc.                             |
| **Country**                    | `character` | Variable with information about the country where the intervention was conducted.                                                           |
| **Language**                   | `character` | Variable with information about the language used in the study.                                                                             |
| **Publishing_status**          | `character` | Indicator equal to one if the study has been published in a journal.                                                                        |
| **RCT_QES**                    | `character` | Variable denoting whether the effect size is from a RCT or a QES                                                                            |
| **Level_treatment_assignment** | `character` | Variable indicating the level of treatment assignment.                                                                                      |
| **Test_subject**               | `character` | Variable denoting the subject of test the effect size is based on (reading or math).                                                        |
| **Estimation_method**          | `character` | Variable indicating the type of estimation method the effect estimate is taken from (e.g., raw means, adjusted means, regression adjusted). |
| **Effectsize_g**               | `numeric`   | Effect size, Hedges' g, not adjusted for clustering.                                                                                        |
| **SE_g**                       | `numeric`   | The standard error of the effect size, not adjusted for clustering.                                                                         |

## References

Dietrichson, J., Filges, T., Seerup, J. K., Klokker, R. H., Viinholt, B.
C. A., Bøg, M., & Eiberg, M. (2021). Targeted school-based interventions
for improving reading and mathematics for students with or at risk of
academic difficulties in Grades K-6: A systematic review. *Campbell
Systematic Reviews*, 17(2), e1152.
[doi:10.1002/cl2.1152](https://doi.org/10.1002/cl2.1152)
