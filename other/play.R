#use_r("h_df_1armcluster")

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

raw_calc <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
  ( (N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-n)*(1-rho)*rho )

df == round(raw_calc, 2)

# Starting up data-raw

usethis::use_data_raw("fadeout")


fadeout
