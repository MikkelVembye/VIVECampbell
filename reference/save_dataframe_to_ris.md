# Write a data frame to a RIS file

Writes a data.frame to a RIS file, one record per row. If a field value
contains semicolons, it is split and written as multiple tag lines. The
`TY` field is written first for each record, followed by all other
fields. Records are terminated with `ER - `.

## Usage

``` r
save_dataframe_to_ris(df, file_path)
```

## Arguments

- df:

  data.frame. The data to write.

- file_path:

  character. Path to the output RIS file.

## Value

A character string indicating the file path where the RIS file was
saved.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- data.frame(TY = "JOUR", TI = "An example", AU = "Doe, J.; Roe, R.")
save_dataframe_to_ris(df, "path/to/output.ris")
} # }
```
