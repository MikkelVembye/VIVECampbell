## code to prepare `fadeout` dataset goes here

library(readxl)

fadeout <- readxl::read_excel("data-raw/FadeoutExtraction.xlsx", 1)

usethis::use_data(fadeout, overwrite = TRUE)
