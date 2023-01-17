#use_r("h_df_1armcluster")

install()
library(VIVECampbell)

load_all()

#df_h_1armcluster(N_total = 100, ICC = 0.1, N_grp = 60, avg_grp_size = 6)
#
#df_h_1armcluster(N_total = 150, ICC = 0.1, N_grp = 100, n_clusters = 10)

df_h(N_total = c(100), ICC = 0.1, avg_grp_size = 10)

df_puste(N_total = c(100, 50), ICC = 0.1, n_clusters = 10)
