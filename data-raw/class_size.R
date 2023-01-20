#read class size data

class_size <- read.csv("data-raw/class_size_dataset.csv")

#save as rdata

usethis::use_data(class_size, overwrite = TRUE)

