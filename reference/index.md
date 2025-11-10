# Package index

## Effect size calculation for binary outcomes

Functions for caclulating effect sizes and sampling variances from
binary outcomes

- [`OR_calc()`](https://mikkelvembye.github.io/VIVECampbell/reference/OR_calc.md)
  : Calculate and cluster bias adjust odds ratios (OR)

## Cluster-bias correction

Functions for caclulating effect sizes and sampling variances from
cluster-designed studies

- [`df_h()`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h.md)
  : Degrees of freedom calculation for cluster bias correction for
  standardized mean differences

## Cluster-bias correction when there is clustering in one treatment group only

Functions for caclulating effect sizes and sampling variances from
cluster-designed studies when there is clustering in one treatment group
only

- [`vgt_smd_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/vgt_smd_1armcluster.md)
  : Variance calculation when there is clustering in one treatment group
  only
- [`df_h_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md)
  : Degrees of freedom calculation for cluster bias correction when
  there is clustering in one treatment group only
- [`eta_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md)
  : Calculating the design effect to cluster bias adjusted sampling
  variances when there is clustering in one treatment group only
- [`gamma_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/gamma_1armcluster.md)
  : Small number of clusters correction when there is clustering in one
  treatment group only

## Sensitivity analysis

Functions to conduct sensitivity analyses in meta-analysis

- [`map_rho_impact()`](https://mikkelvembye.github.io/VIVECampbell/reference/map_rho_impact.md)
  : Conduct sensitivity analyses across various values of the assumed
  sample correlation on the overall average effect in the CHE-RVE model
- [`plot_rho_impact()`](https://mikkelvembye.github.io/VIVECampbell/reference/plot_rho_impact.md)
  : Plotting the impact of the assumed sampling correlation on the
  overall average effect size estimate
- [`plot_rho_impact(`*`<map_rho>`*`)`](https://mikkelvembye.github.io/VIVECampbell/reference/plot_rho_impact.map_rho.md)
  : Plotting the impact of the assumed sampling correlation on the
  overall average effect size estimate

## Datasets

Data from Systematic Reviews from the VIVE Campbell group

- [`Dietrichson2021_data`](https://mikkelvembye.github.io/VIVECampbell/reference/Dietrichson2021_data.md)
  : Targeted school-based interventions data (K-6)
- [`fadeout`](https://mikkelvembye.github.io/VIVECampbell/reference/fadeout.md)
  : Fadeout data

## RIS file functions

Functions to load RIS files to data frames and save data frames as RIS
files

- [`read_ris_to_dataframe()`](https://mikkelvembye.github.io/VIVECampbell/reference/read_ris_to_dataframe.md)
  : Read an RIS file into a data frame
- [`save_dataframe_to_ris()`](https://mikkelvembye.github.io/VIVECampbell/reference/save_dataframe_to_ris.md)
  : Write a data frame to a RIS file
