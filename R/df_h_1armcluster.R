
df_h_1armcluster <- 
  function(total_sample_size, ICC, grp_sample_size, avg_grp_size){
    
    N <- total_sample_size
    rho <- ICC
    NT <- grp_sample_size
    n <- avg_grp_size
    
    h <- ((N-2)*(1-rho) + (NT-n)*rho)^2 /
      ((N-2)*(1-rho)^2 + (NT-n)*n*rho^2 + 2*(NT-2)*(1-rho)*rho)
    
    h
  }