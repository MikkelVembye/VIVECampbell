# Samle mange ris-filer til en (eller flere) fil(er) i R

**Vigtig note**

Hvis du ikke har en R-version lig med eller over 4.1.0, skal du være
opmærksom på, at de koder jeg viser i denne vignette ikke umiddelbart
virker, da jeg benytter R base pipen `|>`. Hvis du ikke ønsker at
opdatere R, kan du bytte `|>` ud med `magrittr` pipen `%>%`. Ydermere
skal man for at kunne køre `revtools`-pakken have installeret en
R-version lig med eller over 3.5.0. I min gennemgang skriver jeg
pakkennavnet (`pakkenavn::`) foran alle funktioner. Hvis man har indlæst
de givne pakker er dette ikke nødvendigt, men jeg gør dette, for at gøre
det tydeligt, hvorfra jeg præcist henter den givne funktion.

Det hænder ofte af forskellige årsager, at vi oplever at vores
bibliometriske søgninger ender ud med en lang række ris-filer. Disse kan
være utroligt trættende at arbejde med, da det kræver meget “peg og
klik” for at kunen indlæse disse i
[EPPI-Reviewer](https://eppi.ioe.ac.uk/EPPIReviewer-Web/home). I denne
vignette viser jeg derfor, hvordan man hurtigt kan samle store mængder
af ris-filer til en eller flere filer ved hjælp af
VIVECampbell::read_ris_to_dataframe (indlæsning) og
VIVECampbell::save_dataframe_to_ris (skrivning).

  
Jeg indlæser først de nødvendige pakker, der skal bruges til at samle
risfilerne.

``` r
library(purrr) # Benyttes til at kunne indlæse flere filer ad gangen
library(stringr) # Benyttes til at sortere ens ris-filer korrekt
library(dplyr) 
```

Første skridt, ift. at indlæse mange (ris-)filer på engang, er at skabe
en string-variabel med alle navnene på alle de ris-filer, som man ønsker
at samle. Dette kan gøres som vist her nedenfor. I dette toy-eksempel,
ønsker vi at samle 5 ris-filer fra EMBASE.

``` r
# Tjek arbejdssti
getwd()

# Ændre evt. arbejdssti via (om nødvendigt)
setwd("Indsæt den ønskede arbejdssti")

# Her skabes vector med alle navnene på de ris-filer, som ønskes indlæst
embase_file_names <- 
  base::list.files(path = "undermappe_til_arbejdssti_1/etc", pattern = "EMBASE") |> 
  stringr::str_sort(numeric = TRUE) # Her sorteres 

embase_file_names
```

    ## [1] "EMBASE_1-200.ris"    "EMBASE_201-400.ris"  "EMBASE_401-600.ris" 
    ## [4] "EMBASE_601-800.ris"  "EMBASE_801-1000.ris"

Vi ser nu alle filer i den givne mappe, hvor “EMBASE” indgår i
filnavnet. Det er vigtigt at tjekke, at
[`list.files()`](https://rdrr.io/r/base/list.files.html) kommandoen gør
sit arbejde og henter navnene på ens ris-filer.[¹](#fn1) Hvis dette step
ikke virker, vil resten af de nedenstående koder heller ikke virke. Hvis
ens arbejdssti-mappe er den samme mappe, som den hvor man har alle sine
ris-filer ligende kan man blot omskrive ovenstående koder som følger,
hvor path-argumentet ignoreres.

``` r
embase_file_names <- 
  base::list.files(pattern = "EMBASE") |> 
  stringr::str_sort(numeric = TRUE) 
```

Når man har skabt en string-variabel med alle navne på de ris-filer, man
ønsker samlet, kan man skabe et stort datasæt med alle referencer fra de
givne ris-filer via
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) og
[`VIVECampbell::read_ris_to_dataframe`](https://mikkelvembye.github.io/VIVECampbell/reference/read_ris_to_dataframe.md),
som konverterer hver RIS-fil til et datasæt i R. Efterfølgende kan
datasættet skrives tilbage som en eller flere RIS-filer med
[`VIVECampbell::save_dataframe_to_ris`](https://mikkelvembye.github.io/VIVECampbell/reference/save_dataframe_to_ris.md).

``` r
ris_file_dat <- 
  purrr::map(embase_file_names, ~ {
    VIVECampbell::read_ris_to_dataframe(file_path = paste0("undermappe_til_arbejdssti_1/", .x)) 
  }
  ) |> 
  purrr::list_rbind() # Benyttes til at samle listen med datasæts som skabes via map()

dplyr::glimpse(ris_file_dat) # Få overblik og det samlede data
```

    ## Rows: 1,000
    ## Columns: 46
    ## $ TY.                                      <chr> "JOUR", "JOUR", "JOUR", "JOUR…
    ## $ DB.                                      <chr> "Embase Preprint", "Embase Pr…
    ## $ AN.                                      <chr> "2031394640", "2029577544", "…
    ## $ T1.                                      <chr> "Mixed Methods Family Centere…
    ## $ A1.                                      <chr> "Kumar J.; Atkinson D.; Chima…
    ## $ AO.                                      <chr> "Chidambaran, Vidya; ORCID: h…
    ## $ Y1.                                      <chr> "2024//", "2023//", "2023//",…
    ## $ N2.                                      <chr> "Background and Objectives: A…
    ## $ KW.                                      <chr> "adult; aged; avoidance behav…
    ## $ JF.                                      <chr> "medRxiv", "bioRxiv", "medRxi…
    ## $ JA.                                      <chr> "medRxiv", "bioRxiv", "medRxi…
    ## $ LA.                                      <chr> "English", "English", "Englis…
    ## $ SP.                                      <chr> "", "", "", "", "", "", "6946…
    ## $ CY.                                      <chr> "United States", "United Stat…
    ## $ PB.                                      <chr> "medRxiv", "bioRxiv", "medRxi…
    ## $ AD.                                      <chr> "V. Chidambaran, Department o…
    ## $ M1.                                      <chr> "(Kumar, Atkinson, Chima, McL…
    ## $ UR.                                      <chr> "https://www.medrxiv.org/", "…
    ## $ DO.                                      <chr> "https://dx.doi.org/10.1101/2…
    ## $ PT.                                      <chr> "Preprint", "Preprint", "Prep…
    ## $ L2.                                      <chr> "http://ovidsp.ovid.com/ovidw…
    ## $ SN.                                      <chr> "", "2692-8205 (electronic); …
    ## $ T3.                                      <chr> "", "", "", "", "", "", "38th…
    ## $ VL.                                      <chr> "", "", "", "", "", "", "30",…
    ## $ IS.                                      <chr> "", "", "", "", "", "", "7", …
    ## $ EP.                                      <chr> "", "", "", "", "", "", "6947…
    ## $ ID.                                      <chr> "", "", "", "", "", "", "", "…
    ## $ XT.                                      <chr> "", "", "", "", "", "", "", "…
    ## $ JF....Brain..Behavior..and.Immunity      <chr> "", "", "", "", "", "", "", "…
    ## $ JA....Brain..Behav...Immun.              <chr> "", "", "", "", "", "", "", "…
    ## $ M2.                                      <chr> "", "", "", "", "", "", "", "…
    ## $ C1.                                      <chr> "", "", "", "", "", "", "", "…
    ## $ C2.                                      <chr> "", "", "", "", "", "", "", "…
    ## $ T1....Healing.grief                      <chr> "", "", "", "", "", "", "", "…
    ## $ AD....P..Sarzi.Puttini..IRCCS.Galeazzi   <chr> "", "", "", "", "", "", "", "…
    ## $ M1.....Sarzi.Puttini..IRCCS.Galeazzi     <chr> "", "", "", "", "", "", "", "…
    ## $ M1.....Nannavecchia..AReSS.Puglia        <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ PB....Mediengruppe.Oberfranken           <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ JF....Kardiologicka.Revue                <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ T1....Burnout.in.healthcare              <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ T3....EuroHeartCare                      <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ M1.....Pape..Oncology..UZ.Ghent          <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ T1.....IT.S.A.MARATHON.AND.NOT.A.SPRINT. <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ C3.                                      <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ C4.                                      <chr> NA, NA, NA, NA, NA, NA, NA, N…
    ## $ M1.....Diekmann..Charite                 <chr> NA, NA, NA, NA, NA, NA, NA, N…

Nu har vi samlet alle referencer fra ris-filerne i et datasæt, og dette
datasæt kan nu skrives til en eller flere RIS-filer med
[`VIVECampbell::save_dataframe_to_ris`](https://mikkelvembye.github.io/VIVECampbell/reference/save_dataframe_to_ris.md).
Nedenfor giver jeg først et eksempel på, hvordan hele datasættet kan
gemmes, og derefter hvordan data kan splittes op og gemmes i flere
ris-filer. Grunden til at vi nogen gange/ofte ønsker at dele filerne op
er, at disse er lettere at arbejde med, eksempelvis i `AIscreenR`, hvor
vi for ikke at bruge unødigt mange penge, gerne deler
screeningsprocessen op i chunks af 500, eller fordi EPPI-Reviewer ofte
kun kan indlæse omkring 4000 almindelige referencer (det afhænger dog af
fil-størrelsen).

``` r
# Gem alle referencer i datasæt i en ris-fil 
VIVECampbell::save_dataframe_to_ris(
  df = ris_file_dat, 
  file_path = "EMBASE_ris_file_1_1000.ris"
)
```

Når man ønsker at splitte data op og gemme flere ris-filer, kan man i de
lette tilfælde gøre dette håndholdt, som følger.

``` r
ris_file_1_500 <- ris_file_dat[1:500,]
ris_file_501_1000 <- ris_file_dat[501:1000,]

VIVECampbell::save_dataframe_to_ris(ris_file_1_500, file_path = "EMBASE_ris_file_1_500.ris")
VIVECampbell::save_dataframe_to_ris(ris_file_501_1000, file_path = "EMBASE_ris_file_501_1000.ris")
```

Det kan dog bare hurtigt ende med at blive trivielt, hvis man
eksempelvis skal dele et datasæt på 100.000 referencer op i blokke af
4000. Det bliver trivielt nok i sig selv at skulle loade disse 25 filer
(100000/4000) til EPPI-reviewer, så for at spare tid, kan man bruge
nedenstående funktion til at gøre gemme-processen hurtigere og mere
effektiv.

``` r
gem_ris <- function(seq, file_name, data){
  start_seq <- min(seq)
  end_seq <- max(seq)
  name_file <- paste0(file_name, "_", start_seq , "_", end_seq, ".ris")
  
  ris_dat <- data[start_seq:end_seq,]
  invisible(VIVECampbell::save_dataframe_to_ris(df = ris_dat, file_path = name_file))
}

# Test at funktionen virker for en delmængde af referencer
#gem_ris(1:500,  file_name = "EMBASE_ris_file", data = ris_file_dat)
```

Derefter køres følgende koder

``` r
# Her indskriver man inddelingssekvensen (alle delmængder). 
# Kan gøres smartere end dette, men dette vil jeg lade stå for nu. 
# Hjælper gerne med at finde andre løsninger hertil, når der er brug for det. 
list_obj <- list(1:500, 501:1000) 

# Denne funktion kan godt tage noget tid at køre, så hav endelig tålmodighed
purrr::map(list_obj, ~ gem_ris(.x,  file_name = "EMBASE_ris_file", data = ris_file_dat))
```

Vær opmærksom på, at med ovenstående eksempel gemmes ris-filerne i
arbejdssti-mappen. Ønsker man filerne gemt i en undermappe, gøres dette
via file_name argumentet i den konstruerede `gem_ris()`-funktion,
eksempelvis således

``` r
purrr::map(
  list_obj, ~ gem_ris(
    .x,  
    file_name = paste0(getwd(), "/undermappe_til_arbejdssti_1/EMBASE_ris_file"), 
    data = ris_file_dat
  )
)
```

------------------------------------------------------------------------

1.  Man kan finde dokumentationen bag R-funktioner ved at indsætte et ?
    foran den givne funktion, eksempelvis således `?list.files()`
