#read class size data
# It needs to be cleaned before it can take part in the package.
# Furthermore, we needed numerical data to be added

class_size <- read.csv("data-raw/class_size_dataset.csv")

#save as rdata

# Use below command, when the data is ready to be included in the package
#usethis::use_data(class_size, overwrite = TRUE)

