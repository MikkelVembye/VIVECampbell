#use_r("h_df_1armcluster")

use_r("rho_impact")

install()
library(VIVECampbell)

load_all()

#df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 6)
#
df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)

df_h(N_total = c(100), ICC = 0.1, avg_grp_size = 10, n_clusters = 10, df_type = "Pustejovsky")


VIVECampbell::Dietrichson2021_data

dplyr::glimpse(Dietrichson2021_data)

use_vignette("VIVECampbell")

# Test change


df <- df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)

# Raw calculation
N <- 100
rho <- 0.1
NT <- 60
n <- 5

raw_calc <- ((N-2)*(1-rho) + (NT-n)*rho)^2 / ( (N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho )

df == round(raw_calc, 2)

# Starting up data-raw

usethis::use_data_raw("fadeout")


fadeout

class_size


Diet_dat <- Dietrichson2021_data |>
  dplyr::mutate(
    vg = SE_g^2,
    studyid = as.numeric(Study_ID),
    esid = 1:n()
  ) |>
  mutate(
    vg_avg = mean(vg),
    .by = studyid
  )

#V <- metafor::vcalc(vg_avg, cluster = studyid, obs = esid, data = Diet_dat, rho = 0.8)
#
#overall_RVE <-
#     metafor::rma.mv(
#       Effectsize_g ~ 1,
#       V = V,
#       random = ~ 1 | studyid / esid,
#       data = Diet_dat
#     ) |>
#     metafor::robust(cluster = studyid, clubSandwich = TRUE)
#
#overall_RVE

#debug(map_rho_impact)


#rho_impact(
#  data = Diet_dat,
#  yi = Effectsize_g,
#  vi = vg,
#  random = "~ 1 | studyid / esid",
#  cluster = Study_ID,
#  r = 0.8,
#  smooth_vi = TRUE
#)

map_rho_impact(
  data = head(Diet_dat, 100),
  yi = Effectsize_g,
  vi = vg,
  studyid = Study_ID,
  r = seq(0, .9, .1)
)

