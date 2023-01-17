#use_r("h_df_1armcluster")

install()
library(VIVECampbell)

load_all()

#df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 6)
#
df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 5)

df_h(N_total = c(100), ICC = 0.1, avg_grp_size = 10)


VIVECampbell::Dietrichson2021_data

dplyr::glimpse(Dietrichson2021_data)
