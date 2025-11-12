# Indtastning af data, effektstørrelsesudregning og cluster bias justering, når der kun er clustering i en gruppe

## Introduktion

**Vigtig note**

Hvis du endnu ikke har arbejdet med R, så har
[Jens](https://www.vive.dk/da/medarbejdere/jens-dietrichson-06zk186j/)
og jeg skrevet den lille blog [“Kom godt i gang med metaanalyse i
R”](https://mikkelvembye.github.io/VIVECampbell/articles/meta-analysis-in-R.html),
som jeg vil anbefale at gennemse sammen med denne blog. Alternativ kan
de også være en god ide at læse det første kapitel i
[R4DS](https://r4ds.had.co.nz/). Nedenfor loader jeg en række af de
pakker som vi ofteste benytter i forbindelse med dataindtastning og
effektstørrelsesudregning. Dog vil jeg fremhæve, at den langt vigtigste
af disse pakker er [`dplyr`](https://dplyr.tidyverse.org/). Det kan være
en ret stor fordel at blive god til grundfunktionerne i denne pakke,
dvs. [`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html),
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html),
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) og
[`select()`](https://dplyr.tidyverse.org/reference/select.html).

  

Denne vignette/blog er tiltænkt at skulle være en basic introduktion til
en række vigtige emner, som er relevante, når man skal indtaste komplex
resultatdata og beregne effektstørrelser fra studier, som skal med i
vores systematiske reviews. En vigtig del af vignetten handler om at
vise, hvordan man benytter funktionerne
[`vgt_smd_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/vgt_smd_1armcluster.md),
[`df_h_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/df_h_1armcluster.md),
[`eta_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/eta_1armcluster.md)
og
[`gamma_1armcluster()`](https://mikkelvembye.github.io/VIVECampbell/reference/gamma_1armcluster.md)
fra `VIVECampbell` R pakken. Vignetten er opbygget som følger: I første
del gennemgår jeg, hvordan kompleks data indtastes, og jeg taler kort
om, hvilket fejl man typisk laver, når man indtaster data. Derefter
viser jeg tre af de mest normale/typiske effektstørrelser, som man
støder på i socialvidenskaben. Herefter viser jeg, hvordan disse kan
beregnes. Jeg viser blandt andet, hvordan man ofte kan beregne
pre-posttest korrelationer mellem outcomes, når vise datastrukturer
afrapporteres i primær forskningen. I den sidste del, viser jeg, hvordan
vi kan kluster bias korrigere vores effekter, når der kun er klustering
i en gruppe samt hvordan man kan estimere varians-covarians matricer for
studier med flere treatment (og/eller kontrol) grupper. Her viser jeg
hvordan man kan benytte
[`vcalc()`](https://wviechtb.github.io/metafor/reference/vcalc.html)
funktionen fra `metafor`-pakken. Afsluttende viser jeg, hvordan man kan
visualisere den konstruerede effektstørrelsesdata.

### Nødvendige pakker og hjælpsomme options

Når du er klar til at gå ombord i denne blog, kan du nedenfor se, de
pakker som bloggen trækker på. Ud fra hver pakke har jeg beskrevet, hvad
pakkens eller optionens primære rolle er. For at hente `VIVECampbell`
skal i fjerne \# foran hhv. `install.packages("devtools")` og
`devtools::install_github("MikkelVembye/VIVECampbell")` og så køre disse
koder. Dette skal kun gøre første gang man kører koderne. Dog ikke
nødvendigt at gøre, hvis man allerede har hentet `VIVECampbell`-pakken.

``` r
#install.packages("devtools")
#devtools::install_github("MikkelVembye/VIVECampbell")

library(VIVECampbell) # Indholder funktioner til at udføre cluster bias justeringer
library(purrr) # Indeholde vigtige loop (map) funktioner, der gør det let at gentage mange ens udregninger og dataændringer
library(dplyr) # Nøglepakke til at manipulere data
library(tidyr) # Indeholder vigtige pivot_ funktioner, som hjælper med at ændre dataset fra wide til long format vice versa
library(gt)    # Tabelkonstruktionens svar på ggplot2
library(ggplot2) # Til at visualisere plot
library(tibble) # En type af data.frames som er mere effektive. I vil se, at jeg altid arbejder med tibbler og ikke rå data.frames
library(metafor) # benytte vi til at beregne variance-covariance matrix

# Options som jeg for det mest benytter
options(pillar.sigfig = 4) # Resultater printes med 4 decimaler
options(tibble.width = Inf) # Sikre at alle variabler printes
options(dplyr.print_min = 310) # Antal rækker som printes fra et datasæt
options(scipen = 10) # Indikerer hvormange decimaler der skal være før R printer videnskabelige numre
options(dplyr.summarise.inform = FALSE) # Undgår info fra summarize() fra dplyr
```

## Kompleks resultdata og hvordan den kan indtastes (long-format)

Når vi laver systematiske reviews, støder vi meget tit på studier, som
afrapporterer rigtig mange resultater, som er relevante for vores
review. Et typisk eksempel kan se ud som Tabel 1 nedenfor fra Fisher &
Bentley ([1996](#ref-Fisher1996)).[¹](#fn1)

[TABLE]

Som det kan ses her, er den resultatsdata som skal udtrækkes relativ
kompleks med pretest, posttest og difference mål nested inden for
treatment grupper (dvs. Disease-and-recovery, Coginitive behavioral og
TAU grupperne), som er nestet inden for kontekster/settings (dvs.
Inpatient og Outpatient settings), som igen er nestet inden for outcomes
(dvs. Alcohol use, Drug use, Social and family relations samt
Psychological functioning). Jeg vil senere vise, hvordan man kan arbejde
med effektstørrelsesdata, hvor man har mere end en treatment- eller
kontrolgruppe. Men først lidt introduktion til en vigtig basic funktion.
Når man vil konstruere et datasæt i R er en vigtig `base::`-funktion at
kende til den som hedder [`rep()`](https://rdrr.io/r/base/rep.html). Den
tillader at replikere de samme værdier på forskellig vis inden for en
given variabel. Nedenfor at vise en række eksempler på, hvordan denne
kan bruges.

``` r
# Her replikeres den samme værdirækkefølge x (dvs. i dette tilfæde 4) gange
rep(LETTERS[1:3], 4)
#>  [1] "A" "B" "C" "A" "B" "C" "A" "B" "C" "A" "B" "C"

# Her replikeres hver værdi x (dvs. i dette tilfæde 3) gange
rep(LETTERS[1:3], each = 3)
#> [1] "A" "A" "A" "B" "B" "B" "C" "C" "C"

# Ovenstående operationer kan også kombineres
rep(LETTERS[1:3], each = 2, 2)
#>  [1] "A" "A" "B" "B" "C" "C" "A" "A" "B" "B" "C" "C"

# Man kan også skabe en variable med en fast antal gentagelser således
rep(LETTERS[1:3], length.out = 11)
#>  [1] "A" "B" "C" "A" "B" "C" "A" "B" "C" "A" "B"

# Igen alle disse operationer kan kombineres i samme funktion
rep(LETTERS[1:3], each = 2, 2, length.out = 11)
#>  [1] "A" "A" "B" "B" "C" "C" "A" "A" "B" "B" "C"
```

Nedenfor viser jeg, hvordan man kunne indtaste data fra Tabel 1 vha.
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) samt
[`rep()`](https://rdrr.io/r/base/rep.html). Måden, hvorpå jeg indtaster
data kaldes af nogen for long format data, hvor hver treatment
gruppernes (dvs. Disease-and-recovery, Coginitive behavioral og TAU)
resultater repræsenteret i hver deres række. Jeg vil senere i bloggen
tale og vise forskellen på long og wide-format data (hvor hver
effektstørrelse har en række), og hvordan man benytter
[`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html)
og
[`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
fra `tidyr`-pakken til at skifte mellem disse to formater.  

  

Når man indtaster data, kan det være en klar fordel at konstruere
treatment/group variabel sådan at treatment gruppen/grupperne kommer
indtastet før kontrol gruppen. Hvis dette gøres er det i hvert fald
lettere at genbruge mine koder fra tidligere projekter, da det altid er
måden jeg gør det på. Derudover benytter jeg aldrig store start
bogstaver, når jeg laver variabelnavne. Det er kun værdierne inden for
en variabel, jeg kan finde på at give store bogstaver.

``` r

Fisher1996 <- tibble::tibble(
  
  outcome = rep(c("Alcohol use", "Drug use", "Social", "Psych func"), each = 6), 
  
  setting = rep(c("Inpatient", "Outpatient"), each = 3, 4),
  
  treatment = rep(c("Disease", "Cognitive", "TAU"), 8),
  
  N = rep(c(6,6,7), 8), 
  
  m_pre = c(
    
    # Alle værider som er indtaster i de andre variable har samme rækkefølge som denne variabel
    # Det er altid en god ide at skrive en vha. # som viser hvilket outcome der indtastes
    
    .469, .441, .349, # Alcohol use - inpatient
    .725, .598, .682, # Alcohol use - outpatient
    
    .107, .116, .117, # Drug use - inpatient 
    .219, .200, .322, # Drug use - outpatient
    
    .342, .419, .450, # Social and family relations - inpatient
    .683, .584, .571, # Social and family relations - outpatient
    
    .393, .498, .605, # Psychological functioning - inpatient  
    .464, .476, .487  # Psychological functioning - outpatient
    
    
  ),
  
  sd_pre = c(
    .12, .13, .22,
    .11, .16, .17,
    
    .09, .10, .12,
    .11, .12, .05,
    
    .21, .12, .24,
    .04, .05, .09,
    
    .17, .13, .15,
    .14, .12, .16
    
  ),
  
  m_post = c(
    .070, .018, .141,
    .521, .152, .492,
    
    .001, .008, .087,
    .167, .044, .216,
    
    .083, .103, .489,
    .641, .233, .514,
    
    .319, .442, .601,
    .432, .232, .472
    
  ),
  
  sd_post = c(
    .11, .05, .21,
    .11, .15, .27,
    
    .01, .02, .12,
    .10, .05, .15,
    
    .10, .10, .18,
    .06, .16, .12,
    
    .14, .16, .18, 
    .18, .07, .18
    
    
  ),
  
  m_diff = c(
    .399, .423, .208,
    .204, .446, .190,
    
    .106, .108, .030,
    .052, .196, .106,
    
    .259, .316, -.039,
    .042, .351, .057,
    
    .074, .056, .004, 
    .032, .244, .015
    
  ),
  
  sd_diff = c(
    .02, .09, .04,
    .01, .02, .11,
    
    .09, .09, .02, 
    .02, .08, .11,
    
    .13, .03, .07,
    .03, .12, .04,
    
    .04, .04, .04,
    .05, .06, .03
    
  ),
  
  # Here we test if the mean differences reported in the study are in line
  # with the differences between the reported pre and post means. It seems to
  # be the case that they make a reporting error for the cognitive outpatient 
  # group mean difference on drug use. Write about the error can be on many levels
  mean_diff_test = m_pre - m_post,
  
); Fisher1996
#> # A tibble: 24 × 11
#>    outcome     setting    treatment     N m_pre sd_pre m_post sd_post m_diff
#>    <chr>       <chr>      <chr>     <dbl> <dbl>  <dbl>  <dbl>   <dbl>  <dbl>
#>  1 Alcohol use Inpatient  Disease       6 0.469   0.12  0.07     0.11  0.399
#>  2 Alcohol use Inpatient  Cognitive     6 0.441   0.13  0.018    0.05  0.423
#>  3 Alcohol use Inpatient  TAU           7 0.349   0.22  0.141    0.21  0.208
#>  4 Alcohol use Outpatient Disease       6 0.725   0.11  0.521    0.11  0.204
#>  5 Alcohol use Outpatient Cognitive     6 0.598   0.16  0.152    0.15  0.446
#>  6 Alcohol use Outpatient TAU           7 0.682   0.17  0.492    0.27  0.19 
#>  7 Drug use    Inpatient  Disease       6 0.107   0.09  0.001    0.01  0.106
#>  8 Drug use    Inpatient  Cognitive     6 0.116   0.1   0.008    0.02  0.108
#>  9 Drug use    Inpatient  TAU           7 0.117   0.12  0.087    0.12  0.03 
#> 10 Drug use    Outpatient Disease       6 0.219   0.11  0.167    0.1   0.052
#> 11 Drug use    Outpatient Cognitive     6 0.2     0.12  0.044    0.05  0.196
#> 12 Drug use    Outpatient TAU           7 0.322   0.05  0.216    0.15  0.106
#> 13 Social      Inpatient  Disease       6 0.342   0.21  0.083    0.1   0.259
#> 14 Social      Inpatient  Cognitive     6 0.419   0.12  0.103    0.1   0.316
#> 15 Social      Inpatient  TAU           7 0.45    0.24  0.489    0.18 -0.039
#> 16 Social      Outpatient Disease       6 0.683   0.04  0.641    0.06  0.042
#> 17 Social      Outpatient Cognitive     6 0.584   0.05  0.233    0.16  0.351
#> 18 Social      Outpatient TAU           7 0.571   0.09  0.514    0.12  0.057
#> 19 Psych func  Inpatient  Disease       6 0.393   0.17  0.319    0.14  0.074
#> 20 Psych func  Inpatient  Cognitive     6 0.498   0.13  0.442    0.16  0.056
#> 21 Psych func  Inpatient  TAU           7 0.605   0.15  0.601    0.18  0.004
#> 22 Psych func  Outpatient Disease       6 0.464   0.14  0.432    0.18  0.032
#> 23 Psych func  Outpatient Cognitive     6 0.476   0.12  0.232    0.07  0.244
#> 24 Psych func  Outpatient TAU           7 0.487   0.16  0.472    0.18  0.015
#>    sd_diff mean_diff_test
#>      <dbl>          <dbl>
#>  1    0.02       0.399   
#>  2    0.09       0.423   
#>  3    0.04       0.208   
#>  4    0.01       0.204   
#>  5    0.02       0.446   
#>  6    0.11       0.19    
#>  7    0.09       0.106   
#>  8    0.09       0.108   
#>  9    0.02       0.03    
#> 10    0.02       0.052   
#> 11    0.08       0.156   
#> 12    0.11       0.106   
#> 13    0.13       0.259   
#> 14    0.03       0.316   
#> 15    0.07      -0.0390  
#> 16    0.03       0.04200 
#> 17    0.12       0.351   
#> 18    0.04       0.05700 
#> 19    0.04       0.074   
#> 20    0.04       0.056   
#> 21    0.04       0.004000
#> 22    0.05       0.03200 
#> 23    0.06       0.244   
#> 24    0.03       0.01500
```

### Typiske fejl, når man indtaster data

Når man benytter [`rep()`](https://rdrr.io/r/base/rep.html) til at skabe
en variabel i et datasæt, er en af de mest typiske fejl man laver, at
man genererer variabler, som ikke har lige mange værdier. Hvis dette er
tilfældet, får man en fejlmelding a la den nedenfor.

``` r

tibble(
  var1 = rep(1:2, 2),
  var2 = rep(c("A", "B"), 3)
)

#Error in `tibble()`:
#! Tibble columns must have compatible sizes.
#• Size 4: Existing data.
#• Size 6: Column at position 2.
#ℹ Only values of size one are recycled.
#Run `rlang::last_trace()` to see where the error occurred.
```

## Effektstørrelsesudregning med kompleks data

Når man får fingrene i så komplekst afrapporteret data som den fra Tabel
1, opstår der en række spørgsmål ift. hvilken typer af effektstørrelser,
som vil være de bedste at beregne, idet man kan vælge en række
forskellige effektstørrelsesindekser i dette tilfælde. Jeg vil her
gennemgå de tre mest kendte typer af effektstørrelser som man vil kunne
beregne ud fra denne data, og vise, hvordan man kan beregne pre-posttest
korrelationer \\\rho\_{prepost}\\, når data er afrapporteret som i Tabel
1.

### Cohens’ \\d\\

Den vel nok mest kendte effektstørrelse, som man vil møde i litteraturen
er den som kaldes Cohens’ \\d\\. Denne effektstørrelse beregnes således

\\\begin{equation} \tag{1} d = \left(\frac{M^T\_{post} -
M^C\_{post}}{SD\_{pool}}\right) \end{equation}\\

hvor \\M^T\_{post}\\ og \\M^C\_{post}\\ er posttestmål for hhv.
treatment og kontrolgruppen, mes \\SD\_{pool}\\ beregnes via

\\\begin{equation} \tag{2} SD\_{pool} = \sqrt{\frac{(n^T\_{post}
-1)\times(SD^T\_{post})^2 + (n^C\_{post}
-1)\times(SD^C\_{post})^2}{n^T + n^C - 2}} \end{equation}\\

\\n^T\\ og \\n^C\\ samt \\SD^T\_{post}\\ og \\SD^C\_{post}\\ er
samplestørrelsen og standardafvigelsen på posttest niveau for hhv.
treatment og kontrolgruppen. Sampling variansen for Cohens’ \\d\\ er
givet ved

\\\begin{equation} \tag{3} Var_d = \left(\frac{1}{n^T} +
\frac{1}{n^C}\right) + \frac{d^2}{2df} \end{equation}\\

hvor \\df = n^T + n^C\\ når der ikke er clusteringproblemer. En meget
vigtig viden, som forhåbentlig kan gøre det lettere at forstå, hvorfor
vi senere laver cluster-justeringer og hvordan vi gennemfører
publikationsbiastests, er, at forstå, at det første led i formel (2),
dvs. \\\left(\frac{1}{n^T} + \frac{1}{n^C}\right)\\, indfanger sampling
variationen for tælleren i formel (1), dvs. \\M^T\_{post} -
M^C\_{post}\\, mens andet led i formel (2), dvs. \\\frac{d^2}{2df}\\
indfanger sampling variansen for nævner i formel (1), dvs.
\\SD\_{pool}\\. Det er første led, som skaber det store bias, hvis et
studie ikke har håndtere klustering korrekt. Så når vi senere kluster
bias korrigerer effekterne fra dette studie, vil i se, at led et få
gange en kluster faktor på sig, som ofte vil gøre dette led substantielt
større. En anden vigtig del ift. formel (3) er at forstå, at andet
leddet i formel (3) (dvs. leddet til højre for \\+\\-tegnet), og senere
formel (8), skaber en falsk korrelation mellem \\d\\ og \\Var_d\\ (se
Pustejovsky & Rodgers, [(2019)](https://doi.org/10.1002/jrsm.1332),
fordi \\d\\ benyttes til at beregne dette led. Når vi estimerer
publikationsbias test fjerner vi derfor dette led, så kan vi ikke
risikerer fejlagtigt at konkludere at små studier oftere afrapporterer
større effekter, som blot skyldes et beregningsartifakt. Variansleddet
vi benytter i publikationsbiastest ser derfor således ud;

\\\begin{equation} \tag{4} W_d = \left(\frac{1}{n^T} +
\frac{1}{n^C}\right) \end{equation}\\

#### Beregning af standardafvigelse baseret på alle grupper i fleregruppe studier

Når man har med fleregruppe studier (dvs. multi-arm trials), som Fisher
studiet her, kan man argumentere for, at en bedre beregning af den
poolede standardafvigelse (SD) ville bero på en SD, som er baseret på
alle målte SDs på tværs af alle grupperne i forsøget. Dermed vil den
poolede SD holdes konstant på af de forskellige effekter. Det er normalt
ikke noget vi benytter i vores reviews, men jeg viser her formlen og
koderne til at beregne denne, hvis man skulle få brug for den. Hvis man
vil bruge denne tilgang, så beregnes den samlede \\SD\_{pool, all}\\
således

\\\begin{equation} \tag{5} SD\_{pool, all} =
\sqrt{\frac{1}{N-T-1}\sum^{T}\_{t=0}(n^t-1)(SD^t\_{post})^2}
\end{equation}\\

hvor \\N = \sum^{T}\_{t=0}n^t\\ for treatmentgrupperne \\t=0,...,T\\ med
\\t=0\\ svarende til kontrolgruppen (\\C\\).

``` r

SD_all_arms <- 
  Fisher1996 |> 
  dplyr::summarise(
    # Her beregner jeg formel (5)
    SD_all_arm = sqrt( (1/(sum(N)-3-1)) * sum((N-1)*sd_post^2) ),
    .by = c(outcome, setting)
  ) |> 
  slice(rep(1:8, 2)) |> 
  arrange(outcome, setting) |> 
  mutate(
    treatment = rep(c("Disease", "Cognitive"), 8)
  ) |> 
  relocate(treatment, .after = setting)
  
```

Det objekt kan senere bindes sammen med vores effektstørrelsesdata.

### Hedges’ \\g\\

En anden meget kendte effektstørrelser er den såkaldte Hedges’ \\g\\.
Forskellen med Cohens’ \\d\\ og Hedges’ \\g\\ er, at Hedges \\g\\
korrigerer en overestimeringfejl i Cohens’ \\d\\. Det vil konkret sige
at Cohens’ \\d\\ bliver for stor ift. den sande bagvedliggende effekt
som forsøges estimeres, når sample størrelsen er lille, dvs. når
\\n^t\<20\\. Derfor ganges en korrektion faktor \\J = 1 -
\frac{3}{(4-df-1)}\\ på formlel (1). Det ser ud således

\\\begin{equation} \tag{6} g = J\left(\frac{M^T\_{post} -
M^C\_{post}}{SD\_{pool}}\right) \end{equation}\\

Larry Hedges, som har udviklet denne effektstørrelse, har senere fundet,
at det ikke er nødvendigt at korrigere variansen for denne
effektstørrelse. Det vil sige, at vi kan beregne sampling variansen med
formel (2). I vil kunne støde på nogle referencer, som ganger \\J^2\\ på
formel (2), men dette ser som sagt ikke længere ud til at være
nødvendigt.

### Glass’ \\\Delta\\

Den sidste også relativt kendte effektstørrelse er Glass’ \\\Delta\\.
Denne effektstørrelse adskiller sig ved, at man kun benytter post-test
standardafvigelsen fra kontrolgruppen, \\SD^C\_{post}\\, til at
standardisere/skalere effektforskellen i formel (1). Det bygger på
antagelsen om, at kontrolgruppen ligner den fulde population mest, da
disse ikke har været udsat for en intervention. Den ser således ud

\\\begin{equation} \tag{7} \Delta = \left(\frac{M^T\_{post} -
M^C\_{post}}{SD^C\_{post}}\right) \end{equation}\\

Formel (2) kan også benyttes til at beregne sampling for \\\Delta\\

### Pretest/baseline adjustede effektstørrelser

Ovenfor har jeg vist en række af de mest kendte og simple
effektstørrelsesformler. Fælles for disse er, at de alle sammen ‘kun’
benytter posttest-effekter til at beregne gennemsnitforskellen mellem
treatment og kontrolgruppen, som beror på den antagelse at de raw means
er unbiased. Det kan dog være en hård antagelse i mange tilfælde, når vi
tillader ikke-randomiserede studier i vores reviews, da means ofte vil
være en biased i forskellig grad grundet brug af samples som ikke er
trukket via randomisering. Dog kan antagelsen også være hård for means,
der kommer fra RCTs, især små RCTer, da samplingfejl selvfølgelig også
kan forekomme i den type af studier. En løsning til at formildne dette
intern validitetsprogram, er at beregne, de såkaldte
difference-in-differences (DID) effektstørrelser (og kaldte
pretest-adjusted effect sizes), hvor man kontrollerer baseline
forskellene på outcme variablen ud mellem treatment og kontrolgruppen.
Vi vil ofte beregne både Hedges’ \\g\\ og DID effektstørrelser, men jeg
er ret stor fan af den sidste og vil altid lægge mest vægt på
fotolkningen af disse, dels fordi denne effektsttørreslser kan reducere
bias og dels fordi den kan estimateres mere præcist (se Hedges et
al. [2023](https://doi.org/10.1111/bmsp.12296)). Formlen for DID
effektstørrelsen er givet ved

\\\begin{equation} \tag{8} g\_{DID} = J \left(\frac{\[M^T\_{post} -
M^T\_{pre}\] - \[M^C\_{post} - M^C\_{pre}\]}{SD\_{pool}}\right)
\end{equation}\\

hvor \\M^T\_{post}\\ og \\M^C\_{post}\\ samt \\M^T\_{pre}\\ og
\\M^C\_{pre}\\ er post- og baselinemål for hhv. treatment- og
kontrolgruppen, og \\SD\_{pool} = \sqrt{\frac{(n^T\_{post}
-1)\times(SD^T\_{post})^2 + (n^C\_{post}
-1)\times(SD^C\_{post})^2}{n^T + n^C - 2}}\\, mens \\n^T\\ og \\n^C\\
samt \\SD^T\_{post}\\ og \\SD^C\_{post}\\ er samplestørrelsen og
standardafvigelsen for hhv. treatment og kontrolgruppen. \\J\\ i formel
(1) er Hedges’ sample sample korrektor lige med \\1 - \frac{3}{4df-1}\\
(nogen trækker 9 fra \\df\\ i stedet for 1, men det har ingen
substantiel betydning).  
  
Hvis vi antager, at der ikke er klusterproblmer, så er \\df = n^T +
n^C\\. Når der er klusteringproblemer kan \\df\\ beregnes via Equation
E.21 ([WWC,
2023](https://ies.ed.gov/ncee/WWC/Docs/referenceresources/Final_WWC-HandbookVer5_0-0-508.pdf),
s. 171) eller hvis der kun er klustering i en gruppe Equation 7 i Hedges
og Citkowicz ([2015](https://doi.org/10.3758/s13428-014-0538-z)).
Sampling variansen for \\g\_{DID}\\ er givet ved

\\\begin{equation} \tag{9} Var\_{g\_{DID}} = \left(\frac{1}{n^T} +
\frac{1}{n^C}\right) 2(1-\rho\_{prepost}) + \frac{g\_{DID}^2}{2df}
\end{equation}\\

Problemet er dog, at man skal kende pre-posttest korrelationen,
\\\rho\_{prepost}\\, for at kunne beregne variansen korrekt. I mange
tilfælde vil vi være i stand til at kunne beregne denne (se eksempel
nedenfor). Se eksemplvis formlerne fra [Cochranes
handbook](https://training.cochrane.org/handbook/current/chapter-06#section-6-5-2-8)
eller formel 31 i Wilson
([2016](https://mason.gmu.edu/~dwilsonb/downloads/esformulas.pdf)). Se
også denne blog på [VIVECampbell
siden](https://mikkelvembye.github.io/VIVECampbell/articles/ancova-puzzler.html).
Alternativt kan \\Var\_{g\_{DID}}\\ beregnes korrekt, hvis forfatterne
har afrapporteret \\t\\- eller \\F\\-værdier fra repeated ANOVA, ANCOVA
eller en regressions model, som har inkluderet pretest-outcome som
kontrol variabel. Hvis dette er tilfældet, så

\\\begin{equation} \tag{10} Var\_{g\_{DID}} = \frac{g\_{DID}^2}{t^2} +
\frac{g\_{DID}^2}{2df} \end{equation}\\

Bemærk her at \\F = t^2\\. Se [James Pustejovskys
blog](https://www.jepusto.com/alternative-formulas-for-the-smd/) for en
yderligere uddybning. Det er igen vigtigt her at notere, at når vi
benytter disse typer af effektstørrelser i publikationsbiastests,
fjernes igen andet leddet (dvs. leddet på højre side af \\+\\-tegnet) i
formlerne (8) og (9).

#### Beregning af pre-posttest korrelation \\\rho\_{prepost}\\

For at kunne beregne sampling variansen for \\g\_{DID}\\ skal vi kende,
estimere eller imputere en værdi for korrelationen mellem pretest og
postscorene, \\\rho\_{prepost}\\. jeg vil på et senere tidspunkt skrive
en blog, hvor jeg vil vise eksempler på alle de måder jeg kender til,
hvorpå man kan bakke ud \\\rho\_{prepost}\\. Når resultaterne er
afrapportet som i Tabel 1, kan vi faktisk udregne den
\\\rho\_{prepost}\\ for hhv. treatment- og kontrolgruppen. Her kan vi
benytte formler fra [Cochranes
handbook](https://training.cochrane.org/handbook/current/chapter-06#section-6-5-2-8),
som for treatmentet gruppen kan beregnes vha

\\\begin{equation} \tag{11} \rho^T\_{prepost} = \frac{(SD^T\_{pre})^2 +
(SD^T\_{post})^2 - (SD^T\_{diff})^2}{2 \times SD^T\_{pre} \times
SD^T\_{post}} \end{equation}\\

og for kontrolgruppen

\\\begin{equation} \tag{12} \rho^C\_{prepost} = \frac{(SD^C\_{pre})^2 +
(SD^C\_{post})^2 - (SD^C\_{diff})^2}{2 \times SD^C\_{pre} \times
SD^C\_{post}} \end{equation}\\

Disse beregninger kan vi faktisk lave/tilføje direkte i vores datasæt
indtastet ovenfor  

``` r
Fisher1996 <- 
  Fisher1996 |> 
  mutate(
  
  # Regnes som i formler (11) og (12). I kan finde disse i Cochrane handbook (Higgins & Thomas, 2019, p. 166).
  r = (sd_pre^2 + sd_post^2-sd_diff^2)/(2 * sd_pre * sd_post ),
  
  ) 
```

Nu kender vi pre-posttest korrelationen for hhv. treatment- og
kontrolgrupperne, men for at kunne beregne \\\rho\_{prepost}\\ skal vi
beregne den gennemsnitlige korrelation baseret på korrelationen fra den
treatment- og kontrolgruppe, som benyttes til at udregne den givne
effektstørrelse. For præcist at kunne beregne denne omregner man
korrelationer til Fishers’ z-scores via \\z_i = 0.5 \times
ln\left(\frac{1+\rho^i\_{prepost}}{1-\rho^i\_{prepost}}\right)\\ med
varians \\v_i = \frac{1}{n-3}\\, hvor \\n\\ er gruppenstørrelsen.
Varians bruges som vægt via \\w_i = \frac{1}{v_i}\\, når Fishers z-score
konverteres tilbage til en korrelation-coefficient, således
\\\rho^i\_{prepost}\\ med flest observationer/individer får størst vægt.
Disse kan beregnes direkte i de råt indtastede data således

``` r

Fisher1996 <- 
  Fisher1996 |> 
  mutate(
  z = 0.5 * log( (1+r)/(1-r) ),
  v = 1/(N-3),
  w = 1/v
  )
```

Den gennemsnitlige Fishers’ z-score på tværs af grupperne kan derefter
beregnes således

\\\begin{equation} \tag{13} \bar{z_r} = \frac{\sum^g\_{i =
1}w_iz_i}{\sum^g\_{i = 1}w_i} \end{equation}\\

Herefter kan den gennemsnitlige pre-posttest korrelation på tværs af
grupper beregnes via

\\\begin{equation} \tag{14} \bar\rho\_{prepost} =
\frac{e^{(2\bar{z_r}})-1}{e^{(2\bar{z_r})}+1} \end{equation}\\

Jeg viser, hvordan dette kan beregnes, som det første i nedenstående
effektstørrelsesudregninger i næste sektion.

## Omsætning af formlerne til beregninger i R

Nedenfor vil jeg vise, hvordan I kan omsætte ovenstående formler, dvs.
beregne Cohens’ \\d\\, Hedges’ \\g\\ samt difference-in-differences
effektstørrelser i R, og senere også hvordan i korrigere disse for
klusterfejl. I eksemplet nedenfor fjerner jeg den ene treatment gruppe
for at forsimple beregningerne. Jeg vil længere nede vise, hvordan I let
kan skabe de samme beregninger på tværs af forskellige
treatment-grupper. Når jeg arbejder med effektstørrelsesdata i R, har
jeg en række regler jeg arbejder ud fra. Den første er, at jeg altid
opkalder det rå effekt-data med efternavnet på førteforfatteren og
udgivelsesåret for studiet, således at objektnavnet bliver `AuthorYear`.
Objektet som indeholder effektstørrelsesudregningerne kalder jeg altid
`AuthorYear_est`. `est` står for ‘**E**ffect **S**izes standardized with
the **T**otal variation’. Lad os springe ud i det.

``` r
Fisher1996_es_disease <- 
  Fisher1996 |> 
  # Her fjerner jeg den treatment gruppen "Cognitive" for at kunne beregne effektstørrelser
  # mellem Diasease og kontrol treatment
  dplyr::filter(treatment != "Cognitive") |> 
  dplyr::summarise(
      study = "Fisher1996",
      treatment = treatment[1],
      main_es_method = "diff-in-diffs",
      
      #Her regner vi den gennemsnitlige Fishers z-score som angivet i formel (13)
      mean_z = sum(w*z)/sum(w),
      #Her beregner vi den gennemsnitlige pre-posttest korrelation som angivet i formel (14) 
      ppcor = (exp(2*mean_z)-1)/(exp(2*mean_z)+1),
      # Her dokumneterer jeg, hvor vi har fundet pre-posttest korrelationen 
      ppcor_calc_method = "Calculated from study results",
      
      # Her laver vi variabler, som viser sample størrelser opdelt på treatment- og kontrolgrupperne
      N_t = N[1],
      N_c = N[2],
      # Her laver vi en variabler med den totale samplestørrelse
      N_tot = sum(N),
      
      # Her laver vi variablen med antal frihedsgrader, som benyttes hhv. til 
      # beregne andet led i variansformlerne (3) og (9) samt til at skabe J faktoren
      # der bruges til beregne Hedges' g
      df_ind = N_tot,
      
      # Her beregnes en pooled standardafvigelse som vist i formel (2)
      sd_pool = sqrt(sum((N - 1) * sd_post^2) / df_ind),
      
      # Beregning af tælleren i formler (1), (6) og (7) 
      # Jeg vender her skalen om, da et fald i scoren på de givne skalaer indikerer en positiv fremgang
      m_diff_post = (m_post[1]-m_post[2])*-1,
      
      # Beregning af Cohens' d fra formel (1)
      d_post = m_diff_post/sd_pool,
      # variansudregning fra formel (3)
      vd_post = sum(1/N) + d_post^2/(2*df_ind),
      # Her beregnes det variansled, som er angivet i formel (4) og benyttes til 
      # publikationsbias testning
      Wd_post = sum(1/N),
      
      # Beregnig af Hedges' g fra formel (6)
      J = 1 - 3/(4*df_ind-1),
      g_post = J * d_post,
      vg_post = vd_post,
      Wg_post = sum(1/N),
      
      # Beregnig af Glass' delta fra formel (7). Vi bruger aldrig denne, så den 
      # er kun med her for eksemplets skyld
      sd_control = sd_post[2],
      delta_post = m_diff_post/sd_control,
      
      # Difference-in-differences (DID) effektstørrelsen
      # Her beregner jeg den raw pre-posteffekt forskelle for hhv. treatment og
      # gruppen.
      diff_t = (m_post[1] - m_pre[1])*-1,
      diff_c = (m_post[2] - m_pre[2])*-1,
      
      # Her skaber jeg så tælleren fra formel (8)
      DD = (diff_t - diff_c),
      
      # Her bergener jeg hele formel (8)
      d_DID = (diff_t - diff_c) / sd_pool,
      # Her beregner jeg formel (9)
      vd_DID = sum(1/N) * (2*(1-ppcor)) + d_DID^2/(2*df_ind),
      # Hvis man vil beregne standardfejlen istedet tager man blot kvadratroden af variansen
      sed_DID = sqrt(vd_DID),
      # Her skabes den variabel som benyttes når vi skal gennemføre publikationsbias tests
      Wd_DID = sum(1/N) * (2*(1-ppcor)),
      
      # Her gøres det samme bare hvor vi indregner sample sample bias korrektoreren J
      g_DID = J * d_DID,
      vg_DID = sum(1/N) * (2*(1-ppcor)) + g_DID^2/(2*df_ind),
      Wg_DID = Wd_DID,
     
     # Effektstørrelserne skal beregne indenfor hver setting og outcome, 
     # Derfor grupperer jeg beregninger således
     .by = c(setting, outcome)
      
     
    ) |> 
    relocate(study)

Fisher1996_es_disease
#> # A tibble: 8 × 33
#>   study      setting    outcome     treatment main_es_method mean_z  ppcor
#>   <chr>      <chr>      <chr>       <chr>     <chr>           <dbl>  <dbl>
#> 1 Fisher1996 Inpatient  Alcohol use Disease   diff-in-diffs   2.480 0.9861
#> 2 Fisher1996 Outpatient Alcohol use Disease   diff-in-diffs   2.598 0.9890
#> 3 Fisher1996 Inpatient  Drug use    Disease   diff-in-diffs   1.442 0.8941
#> 4 Fisher1996 Outpatient Drug use    Disease   diff-in-diffs   1.806 0.9475
#> 5 Fisher1996 Inpatient  Social      Disease   diff-in-diffs   1.996 0.9637
#> 6 Fisher1996 Outpatient Social      Disease   diff-in-diffs   1.795 0.9463
#> 7 Fisher1996 Inpatient  Psych func  Disease   diff-in-diffs   2.489 0.9863
#> 8 Fisher1996 Outpatient Psych func  Disease   diff-in-diffs   2.562 0.9882
#>   ppcor_calc_method               N_t   N_c N_tot df_ind sd_pool m_diff_post
#>   <chr>                         <dbl> <dbl> <dbl>  <dbl>   <dbl>       <dbl>
#> 1 Calculated from study results     6     7    13     13 0.1581      0.071  
#> 2 Calculated from study results     6     7    13     13 0.1957     -0.02900
#> 3 Calculated from study results     6     7    13     13 0.08176     0.086  
#> 4 Calculated from study results     6     7    13     13 0.1193      0.049  
#> 5 Calculated from study results     6     7    13     13 0.1371      0.406  
#> 6 Calculated from study results     6     7    13     13 0.08961    -0.127  
#> 7 Calculated from study results     6     7    13     13 0.1500      0.282  
#> 8 Calculated from study results     6     7    13     13 0.1656      0.0400 
#>    d_post vd_post Wd_post      J  g_post vg_post Wg_post sd_control delta_post
#>     <dbl>   <dbl>   <dbl>  <dbl>   <dbl>   <dbl>   <dbl>      <dbl>      <dbl>
#> 1  0.4490  0.3173  0.3095 0.9412  0.4226  0.3173  0.3095       0.21     0.3381
#> 2 -0.1482  0.3104  0.3095 0.9412 -0.1395  0.3104  0.3095       0.27    -0.1074
#> 3  1.052   0.3521  0.3095 0.9412  0.9900  0.3521  0.3095       0.12     0.7167
#> 4  0.4108  0.3160  0.3095 0.9412  0.3866  0.3160  0.3095       0.15     0.3267
#> 5  2.961   0.6467  0.3095 0.9412  2.787   0.6467  0.3095       0.18     2.256 
#> 6 -1.417   0.3868  0.3095 0.9412 -1.334   0.3868  0.3095       0.12    -1.058 
#> 7  1.880   0.4455  0.3095 0.9412  1.770   0.4455  0.3095       0.18     1.567 
#> 8  0.2416  0.3118  0.3095 0.9412  0.2274  0.3118  0.3095       0.18     0.2222
#>    diff_t    diff_c       DD    d_DID   vd_DID sed_DID   Wd_DID    g_DID
#>     <dbl>     <dbl>    <dbl>    <dbl>    <dbl>   <dbl>    <dbl>    <dbl>
#> 1 0.399    0.208     0.191    1.208   0.06473  0.2544  0.008626  1.137  
#> 2 0.204    0.19      0.01400  0.07154 0.007011 0.08373 0.006814  0.06733
#> 3 0.106    0.03      0.076    0.9296  0.09882  0.3144  0.06558   0.8749 
#> 4 0.052    0.106    -0.054   -0.4527  0.04040  0.2010  0.03252  -0.4260 
#> 5 0.259   -0.0390    0.298    2.173   0.2041   0.4518  0.02246   2.046  
#> 6 0.04200  0.05700  -0.01500 -0.1674  0.03433  0.1853  0.03326  -0.1575 
#> 7 0.074    0.004000  0.07     0.4667  0.01685  0.1298  0.008471  0.4393 
#> 8 0.03200  0.01500   0.01700  0.1027  0.007729 0.08791 0.007323  0.09663
#>     vg_DID   Wg_DID
#>      <dbl>    <dbl>
#> 1 0.05833  0.008626
#> 2 0.006989 0.006814
#> 3 0.09502  0.06558 
#> 4 0.03950  0.03252 
#> 5 0.1834   0.02246 
#> 6 0.03421  0.03326 
#> 7 0.01589  0.008471
#> 8 0.007682 0.007323
```

### Funktion til effektstørrelsesberegning med mere end to treatment- og/eller kontrolgrupper

Ovenfor har jeg vist, hvordan man kan beregne effektstørrelser, når der
er en treatment gruppe. Nu vil jeg vise, hvordan man brugen
funktionskabning til at lave de samme beregninger for flere
treatmentgrupper, der skal sammenlignes med den samme kontrolgruppe, som
i dette tilfælde vi beskæftiger os med.

``` r
treat_label_fisher <- unique(Fisher1996$treatment)[1:2]

fisher_func <- function(label){
  
  Fisher_effects <- 
  Fisher1996 |> 
  # Her fjerner jeg den treatment gruppen "Cognitive" for at kunne beregne effektstørrelser
  # mellem Diasease og kontrol treatment
  dplyr::filter(treatment != label) |> 
  dplyr::summarise(
      study = "Fisher1996",
      treatment = treatment[1],
      main_es_method = "diff-in-diffs",
      
      #Her regner vi den gennemsnitlige Fishers z-score som angivet i formel (12)
      mean_z = sum(w*z)/sum(w),
      #Her beregner vi den gennemsnitlige pre-posttest korrelation som angivet i formel (13) 
      ppcor = (exp(2*mean_z)-1)/(exp(2*mean_z)+1),
      # Her dokumneterer jeg, hvor vi har fundet pre-posttest korrelationen 
      ppcor_calc_method = "Calculated from study results",
      
      # Her laver vi variabler, som viser sample størrelser opdelt på treatment- og kontrolgrupperne
      N_t = N[1],
      N_c = N[2],
      # Her laver vi en variabler med den totale samplestørrelse
      N_tot = sum(N),
      
      # Her laver vi variablen med antal frihedsgrader, som benyttes hhv. til 
      # beregne andet led i variansformlerne (3) og (9) samt til at skabe J faktoren
      # der bruges til beregne Hedges' g
      df_ind = N_tot,
      
      # Her beregnes en pooled standardafvigelse som vist i formel (2)
      sd_pool = sqrt(sum((N - 1) * sd_post^2) / df_ind),
      
      # Beregning af tælleren i formler (1), (6) og (7) 
      # Jeg vender her skalen om, da et fald i scoren på de givne skalaer indikerer en positiv fremgang
      m_diff_post = (m_post[1]-m_post[2])*-1,
      
      # Beregning af Cohens' d fra formel (1)
      d_post = m_diff_post/sd_pool,
      # variansudregning fra formel (3)
      vd_post = sum(1/N) + d_post^2/(2*df_ind),
      # Her beregnes det variansled, som er angivet i formel (4) og benyttes til 
      # publikationsbias testning
      Wd_post = sum(1/N),
      
      # Beregnig af Hedges' g fra formel (6)
      J = 1 - 3/(4*df_ind-1),
      g_post = J * d_post,
      vg_post = vd_post,
      Wg_post = sum(1/N),
      
      # Beregnig af Glass' delta fra formel (7). Vi bruger aldrig denne, så den 
      # er kun med her for eksemplets skyld
      sd_control = sd_post[2],
      delta_post = m_diff_post/sd_control,
      
      # Difference-in-differences (DID) effektstørrelsen
      # Her beregner jeg den raw pre-posteffekt forskelle for hhv. treatment og
      # gruppen.
      diff_t = (m_post[1] - m_pre[1])*-1,
      diff_c = (m_post[2] - m_pre[2])*-1,
      
      # Her skaber jeg så tælleren fra formel (8)
      DD = (diff_t - diff_c),
      
      # Her bergener jeg hele formel (8)
      d_DID = (diff_t - diff_c) / sd_pool,
      # Her beregner jeg formel (9)
      vd_DID = sum(1/N) * (2*(1-ppcor)) + d_DID^2/(2*df_ind),
      # Hvis man vil beregne standardfejlen istedet tager man blot kvadratroden af variansen
      sed_DID = sqrt(vd_DID),
      # Her skabes den variabel som benyttes når vi skal gennemføre publikationsbias tests
      Wd_DID = sum(1/N) * (2*(1-ppcor)),
      
      # Her gøres det samme bare hvor vi indregner sample sample bias korrektoreren J
      g_DID = J * d_DID,
      vg_DID = sum(1/N) * (2*(1-ppcor)) + g_DID^2/(2*df_ind),
      Wg_DID = Wd_DID,
     
     # Effektstørrelserne skal beregne indenfor hver setting og outcome, 
     # Derfor grupperer jeg beregninger således
     .by = c(setting, outcome)
      
     
    ) |> 
    relocate(study)

  # Her omformer jeg Fisher1996 til et wide format, så det har samme længde, som 
  # effect størrelsesdatasæt ovenfor
  Fisher_raw_dat_wide <- 
   Fisher1996 |> 
   filter(treatment %in% c(label, "TAU")) |> 
   mutate(
     treatment = if_else(treatment == label, "t", "c")
   ) |> 
   pivot_wider(
     names_from = treatment, 
     values_from = N:w
   ) |> 
  mutate(
    group_t = label,
    group_c = "TAU"  
  ) |> 
  relocate(group_t:group_c, .after = setting)

 # Her binder jeg de raw mål sammen med effectstørrelsesudregningerne
 left_join(Fisher_raw_dat_wide, Fisher_effects, by = join_by(outcome, setting, N_t, N_c))
  
  
}

# Her bruger jeg funktionen til at beregne effekter for begge treatments holdt op imod den
# samme kontrol gruppe
Fisher1996_es <- 
  purrr::map(treat_label_fisher, ~ fisher_func(.x)) |> 
  list_rbind() |> 
  mutate(
    study = "Fisher (1996)"
  ) |> 
  relocate(study) |> 
  arrange(setting, outcome) |> 
  relocate(setting, .before = outcome)

Fisher1996_es
#> # A tibble: 16 × 57
#>    study         setting    outcome     group_t   group_c   N_t   N_c m_pre_t
#>    <chr>         <chr>      <chr>       <chr>     <chr>   <dbl> <dbl>   <dbl>
#>  1 Fisher (1996) Inpatient  Alcohol use Disease   TAU         6     7   0.469
#>  2 Fisher (1996) Inpatient  Alcohol use Cognitive TAU         6     7   0.441
#>  3 Fisher (1996) Inpatient  Drug use    Disease   TAU         6     7   0.107
#>  4 Fisher (1996) Inpatient  Drug use    Cognitive TAU         6     7   0.116
#>  5 Fisher (1996) Inpatient  Psych func  Disease   TAU         6     7   0.393
#>  6 Fisher (1996) Inpatient  Psych func  Cognitive TAU         6     7   0.498
#>  7 Fisher (1996) Inpatient  Social      Disease   TAU         6     7   0.342
#>  8 Fisher (1996) Inpatient  Social      Cognitive TAU         6     7   0.419
#>  9 Fisher (1996) Outpatient Alcohol use Disease   TAU         6     7   0.725
#> 10 Fisher (1996) Outpatient Alcohol use Cognitive TAU         6     7   0.598
#> 11 Fisher (1996) Outpatient Drug use    Disease   TAU         6     7   0.219
#> 12 Fisher (1996) Outpatient Drug use    Cognitive TAU         6     7   0.2  
#> 13 Fisher (1996) Outpatient Psych func  Disease   TAU         6     7   0.464
#> 14 Fisher (1996) Outpatient Psych func  Cognitive TAU         6     7   0.476
#> 15 Fisher (1996) Outpatient Social      Disease   TAU         6     7   0.683
#> 16 Fisher (1996) Outpatient Social      Cognitive TAU         6     7   0.584
#>    m_pre_c sd_pre_t sd_pre_c m_post_t m_post_c sd_post_t sd_post_c m_diff_t
#>      <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>     <dbl>    <dbl>
#>  1   0.349     0.12     0.22    0.07     0.141      0.11      0.21    0.399
#>  2   0.349     0.13     0.22    0.018    0.141      0.05      0.21    0.423
#>  3   0.117     0.09     0.12    0.001    0.087      0.01      0.12    0.106
#>  4   0.117     0.1      0.12    0.008    0.087      0.02      0.12    0.108
#>  5   0.605     0.17     0.15    0.319    0.601      0.14      0.18    0.074
#>  6   0.605     0.13     0.15    0.442    0.601      0.16      0.18    0.056
#>  7   0.45      0.21     0.24    0.083    0.489      0.1       0.18    0.259
#>  8   0.45      0.12     0.24    0.103    0.489      0.1       0.18    0.316
#>  9   0.682     0.11     0.17    0.521    0.492      0.11      0.27    0.204
#> 10   0.682     0.16     0.17    0.152    0.492      0.15      0.27    0.446
#> 11   0.322     0.11     0.05    0.167    0.216      0.1       0.15    0.052
#> 12   0.322     0.12     0.05    0.044    0.216      0.05      0.15    0.196
#> 13   0.487     0.14     0.16    0.432    0.472      0.18      0.18    0.032
#> 14   0.487     0.12     0.16    0.232    0.472      0.07      0.18    0.244
#> 15   0.571     0.04     0.09    0.641    0.514      0.06      0.12    0.042
#> 16   0.571     0.05     0.09    0.233    0.514      0.16      0.12    0.351
#>    m_diff_c sd_diff_t sd_diff_c mean_diff_test_t mean_diff_test_c     r_t    r_c
#>       <dbl>     <dbl>     <dbl>            <dbl>            <dbl>   <dbl>  <dbl>
#>  1    0.208      0.02      0.04          0.399           0.208    0.9886  0.9838
#>  2    0.208      0.09      0.04          0.423           0.208    0.8692  0.9838
#>  3    0.03       0.09      0.02          0.106           0.03     0.05556 0.9861
#>  4    0.03       0.09      0.02          0.108           0.03     0.5750  0.9861
#>  5    0.004      0.04      0.04          0.074           0.004000 0.9853  0.9870
#>  6    0.004      0.04      0.04          0.056           0.004000 0.9832  0.9870
#>  7   -0.039      0.13      0.07          0.259          -0.0390   0.8857  0.9850
#>  8   -0.039      0.03      0.07          0.316          -0.0390   0.9792  0.9850
#>  9    0.19       0.01      0.11          0.204           0.19     0.9959  0.9771
#> 10    0.19       0.02      0.11          0.446           0.19     0.9938  0.9771
#> 11    0.106      0.02      0.11          0.052           0.106    0.9864  0.86  
#> 12    0.106      0.08      0.11          0.156           0.106    0.875   0.86  
#> 13    0.015      0.05      0.03          0.03200         0.01500  0.9821  0.9913
#> 14    0.015      0.06      0.03          0.244           0.01500  0.9345  0.9913
#> 15    0.057      0.03      0.04          0.04200         0.05700  0.8958  0.9676
#> 16    0.057      0.12      0.04          0.351           0.05700  0.8562  0.9676
#>        z_t   z_c    v_t   v_c   w_t   w_c treatment main_es_method mean_z  ppcor
#>      <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>     <chr>           <dbl>  <dbl>
#>  1 2.582   2.403 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.943 0.9598
#>  2 1.330   2.403 0.3333  0.25     3     4 Disease   diff-in-diffs   2.480 0.9861
#>  3 0.05561 2.481 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.699 0.9352
#>  4 0.6550  2.481 0.3333  0.25     3     4 Disease   diff-in-diffs   1.442 0.8941
#>  5 2.453   2.516 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.460 0.9855
#>  6 2.385   2.516 0.3333  0.25     3     4 Disease   diff-in-diffs   2.489 0.9863
#>  7 1.402   2.441 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.371 0.9827
#>  8 2.277   2.441 0.3333  0.25     3     4 Disease   diff-in-diffs   1.996 0.9637
#>  9 3.090   2.230 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.509 0.9869
#> 10 2.883   2.230 0.3333  0.25     3     4 Disease   diff-in-diffs   2.598 0.9890
#> 11 2.491   1.293 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.319 0.8666
#> 12 1.354   1.293 0.3333  0.25     3     4 Disease   diff-in-diffs   1.806 0.9475
#> 13 2.355   2.718 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.279 0.9792
#> 14 1.693   2.718 0.3333  0.25     3     4 Disease   diff-in-diffs   2.562 0.9882
#> 15 1.451   2.053 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.721 0.9380
#> 16 1.279   2.053 0.3333  0.25     3     4 Disease   diff-in-diffs   1.795 0.9463
#>    ppcor_calc_method             N_tot df_ind sd_pool m_diff_post  d_post
#>    <chr>                         <dbl>  <dbl>   <dbl>       <dbl>   <dbl>
#>  1 Calculated from study results    13     13 0.1460      0.123    0.8425
#>  2 Calculated from study results    13     13 0.1581      0.071    0.4490
#>  3 Calculated from study results    13     13 0.08246     0.079    0.9580
#>  4 Calculated from study results    13     13 0.08176     0.086    1.052 
#>  5 Calculated from study results    13     13 0.1575      0.159    1.010 
#>  6 Calculated from study results    13     13 0.1500      0.282    1.880 
#>  7 Calculated from study results    13     13 0.1371      0.386    2.815 
#>  8 Calculated from study results    13     13 0.1371      0.406    2.961 
#>  9 Calculated from study results    13     13 0.2057      0.34     1.653 
#> 10 Calculated from study results    13     13 0.1957     -0.02900 -0.1482
#> 11 Calculated from study results    13     13 0.1065      0.172    1.615 
#> 12 Calculated from study results    13     13 0.1193      0.049    0.4108
#> 13 Calculated from study results    13     13 0.1298      0.24     1.850 
#> 14 Calculated from study results    13     13 0.1656      0.0400   0.2416
#> 15 Calculated from study results    13     13 0.1284      0.281    2.188 
#> 16 Calculated from study results    13     13 0.08961    -0.127   -1.417 
#>    vd_post Wd_post      J  g_post vg_post Wg_post sd_control delta_post  diff_t
#>      <dbl>   <dbl>  <dbl>   <dbl>   <dbl>   <dbl>      <dbl>      <dbl>   <dbl>
#>  1  0.3368  0.3095 0.9412  0.7929  0.3368  0.3095       0.21     0.5857 0.423  
#>  2  0.3173  0.3095 0.9412  0.4226  0.3173  0.3095       0.21     0.3381 0.399  
#>  3  0.3448  0.3095 0.9412  0.9017  0.3448  0.3095       0.12     0.6583 0.108  
#>  4  0.3521  0.3095 0.9412  0.9900  0.3521  0.3095       0.12     0.7167 0.106  
#>  5  0.3487  0.3095 0.9412  0.9503  0.3487  0.3095       0.18     0.8833 0.056  
#>  6  0.4455  0.3095 0.9412  1.770   0.4455  0.3095       0.18     1.567  0.074  
#>  7  0.6143  0.3095 0.9412  2.650   0.6143  0.3095       0.18     2.144  0.316  
#>  8  0.6467  0.3095 0.9412  2.787   0.6467  0.3095       0.18     2.256  0.259  
#>  9  0.4146  0.3095 0.9412  1.556   0.4146  0.3095       0.27     1.259  0.446  
#> 10  0.3104  0.3095 0.9412 -0.1395  0.3104  0.3095       0.27    -0.1074 0.204  
#> 11  0.4098  0.3095 0.9412  1.520   0.4098  0.3095       0.15     1.147  0.156  
#> 12  0.3160  0.3095 0.9412  0.3866  0.3160  0.3095       0.15     0.3267 0.052  
#> 13  0.4411  0.3095 0.9412  1.741   0.4411  0.3095       0.18     1.333  0.244  
#> 14  0.3118  0.3095 0.9412  0.2274  0.3118  0.3095       0.18     0.2222 0.03200
#> 15  0.4937  0.3095 0.9412  2.059   0.4937  0.3095       0.12     2.342  0.351  
#> 16  0.3868  0.3095 0.9412 -1.334   0.3868  0.3095       0.12    -1.058  0.04200
#>       diff_c       DD    d_DID   vd_DID sed_DID   Wd_DID    g_DID   vg_DID
#>        <dbl>    <dbl>    <dbl>    <dbl>   <dbl>    <dbl>    <dbl>    <dbl>
#>  1  0.208     0.215    1.473   0.1083   0.3291  0.02490   1.386   0.09879 
#>  2  0.208     0.191    1.208   0.06473  0.2544  0.008626  1.137   0.05833 
#>  3  0.03      0.078    0.9459  0.07450  0.2729  0.04009   0.8902  0.07057 
#>  4  0.03      0.076    0.9296  0.09882  0.3144  0.06558   0.8749  0.09502 
#>  5  0.004000  0.052    0.3302  0.01317  0.1148  0.008975  0.3108  0.01269 
#>  6  0.004000  0.07     0.4667  0.01685  0.1298  0.008471  0.4393  0.01589 
#>  7 -0.0390    0.355    2.589   0.2685   0.5182  0.01071   2.437   0.2391  
#>  8 -0.0390    0.298    2.173   0.2041   0.4518  0.02246   2.046   0.1834  
#>  9  0.19      0.256    1.245   0.06772  0.2602  0.008132  1.171   0.06092 
#> 10  0.19      0.01400  0.07154 0.007011 0.08373 0.006814  0.06733 0.006989
#> 11  0.106     0.05     0.4694  0.09104  0.3017  0.08257   0.4418  0.09007 
#> 12  0.106    -0.054   -0.4527  0.04040  0.2010  0.03252  -0.4260  0.03950 
#> 13  0.01500   0.229    1.765   0.1326   0.3642  0.01286   1.661   0.1190  
#> 14  0.01500   0.01700  0.1027  0.007729 0.08791 0.007323  0.09663 0.007682
#> 15  0.05700   0.294    2.289   0.2399   0.4898  0.03836   2.155   0.2169  
#> 16  0.05700  -0.01500 -0.1674  0.03433  0.1853  0.03326  -0.1575  0.03421 
#>      Wg_DID
#>       <dbl>
#>  1 0.02490 
#>  2 0.008626
#>  3 0.04009 
#>  4 0.06558 
#>  5 0.008975
#>  6 0.008471
#>  7 0.01071 
#>  8 0.02246 
#>  9 0.008132
#> 10 0.006814
#> 11 0.08257 
#> 12 0.03252 
#> 13 0.01286 
#> 14 0.007323
#> 15 0.03836 
#> 16 0.03326
```

### Cluster bias korrektion når der kun er klustering i en gruppe

  
\\\begin{equation} \tag{15} gt\_{DID} = \omega\left(\frac{M^T\_{post} -
M^C\_{post}}{SD\_{pool}}\right)\gamma \end{equation}\\  

hvor \\\omega = 1 - 3/(4-df_h-1)\\, hvor \\df_h\\ er de klusterjusterede
frihedsgrader, som beregnes for således når der kun er klustering i en
gruppe

  
\\\begin{equation} \tag{16} h =
\dfrac{\[(N-2)-2(n-1)\rho\]^2}{(N-2)(1-\rho)^2 + n(N-2n)\rho^2 +
2(N-2n)\rho(1-\rho)} \end{equation}\\  

i formel 14 er \\\gamma = \sqrt{1-\frac{(N^c +n-2)\rho\_{ICC}}{}}\\

``` r

# Imputerede ICC-værdier
icc_005 <- 0.05 # Bruges til sensitivitetsanalyse
icc_01 <- 0.1
icc_02 <- 0.2 # Bruges til sensitivitetsanalyse

Fisher1996_est <- 
  Fisher1996_es |> 
  rowwise() |> 
  # klusterkorrigering
  mutate(
    
    # Gruppestørrelsen kan ikke findes i Fisher 1996, så her imputerer vi blot den 
    # gennemsnitlige gruppestørrelse for eksemplet skyld
    n_group = 5,
    # Laver variabel med den imputere ICC værdi
    icc = icc_01,
    # Laver variabel som dokumenterer hvor vi fandt ICC-værdieen
    icc_type = "Imputed",
    
    gamma_sqrt = VIVECampbell::gamma_1armcluster(
      N_total = N_tot, Nc = N_c, avg_grp_size = n_group, ICC = icc, sqrt = TRUE
    ), 
    gamma_sqrt_test = sqrt(1 - (N_c + n_group-2)*icc/(N_tot-2)), 
    
    h = df_h_1armcluster(N_total = N_tot, ICC = icc, N_grp = N_t, avg_grp_size = n_group),
    omega = 1 - 3/(4*h-1),
      
    gt_post = omega * d_post * gamma_sqrt,
    VIVECampbell::vgt_smd_1armcluster(
      N_cl_grp = N_t, 
      N_ind_grp = N_c, 
      avg_grp_size = n_group,
      ICC = icc, 
      g = gt_post, 
      model = "posttest",
      add_name_to_vars = "_post",
      vars = c(vgt_post, Wgt_post)
    ),
    
    gt_DID = omega * d_DID * gamma_sqrt,
    VIVECampbell::vgt_smd_1armcluster(
      N_cl_grp = N_t, 
      N_ind_grp = N_c, 
      avg_grp_size = n_group,
      ICC = icc, 
      g = gt_DID, 
      model = "DiD",
      prepost_cor = ppcor,
      add_name_to_vars = "_DID",
      vars = -var_term1_DID
    ),
    
    # Disse variabler skabes til at lave sensitivitetsanalyser
    
    # Her antager vi at ICC = 0.05
    gamma_sqrt_005 = VIVECampbell::gamma_1armcluster(
      N_total = N_tot, Nc = N_c, avg_grp_size = n_group, ICC = icc_005, sqrt = TRUE
    ), 
    h_005 = df_h_1armcluster(N_total = N_tot, ICC = icc_005, N_grp = N_t, avg_grp_size = n_group),
    omega_005 = 1 - 3/(4*h_005-1),
    
    gt_DID_005 = omega_005 * d_DID * gamma_sqrt_005,
    VIVECampbell::vgt_smd_1armcluster(
      N_cl_grp = N_t, 
      N_ind_grp = N_c, 
      avg_grp_size = n_group,
      ICC = icc_005, # Husk at ændre denne
      g = gt_DID_005, #Husk at ændre denne
      model = "DiD",
      prepost_cor = ppcor,
      add_name_to_vars = "_DID_005",
      vars = c(vgt_DID_005, Wgt_DID_005)
    ),
    
    # Her antager vi at ICC = 0.2
    gamma_sqrt_02 = VIVECampbell::gamma_1armcluster(
      N_total = N_tot, Nc = N_c, avg_grp_size = n_group, ICC = icc_02, sqrt = TRUE
    ), 
    h_02 = df_h_1armcluster(N_total = N_tot, ICC = icc_02, N_grp = N_t, avg_grp_size = n_group),
    omega_02 = 1 - 3/(4*h_02-1),
    
    gt_DID_02 = omega_02 * d_DID * gamma_sqrt_02,
    VIVECampbell::vgt_smd_1armcluster(
      N_cl_grp = N_t, 
      N_ind_grp = N_c, 
      avg_grp_size = n_group,
      ICC = icc_02, 
      g = gt_DID_02, 
      model = "DiD",
      prepost_cor = ppcor,
      add_name_to_vars = "_DID_02",
      vars = c(vgt_DID_02, Wgt_DID_02)
    ),
    
    vary_id = paste(setting, outcome, treatment, sep = "/")
  ) |> 
  ungroup()

Fisher1996_est
#> # A tibble: 16 × 90
#>    study         setting    outcome     group_t   group_c   N_t   N_c m_pre_t
#>    <chr>         <chr>      <chr>       <chr>     <chr>   <dbl> <dbl>   <dbl>
#>  1 Fisher (1996) Inpatient  Alcohol use Disease   TAU         6     7   0.469
#>  2 Fisher (1996) Inpatient  Alcohol use Cognitive TAU         6     7   0.441
#>  3 Fisher (1996) Inpatient  Drug use    Disease   TAU         6     7   0.107
#>  4 Fisher (1996) Inpatient  Drug use    Cognitive TAU         6     7   0.116
#>  5 Fisher (1996) Inpatient  Psych func  Disease   TAU         6     7   0.393
#>  6 Fisher (1996) Inpatient  Psych func  Cognitive TAU         6     7   0.498
#>  7 Fisher (1996) Inpatient  Social      Disease   TAU         6     7   0.342
#>  8 Fisher (1996) Inpatient  Social      Cognitive TAU         6     7   0.419
#>  9 Fisher (1996) Outpatient Alcohol use Disease   TAU         6     7   0.725
#> 10 Fisher (1996) Outpatient Alcohol use Cognitive TAU         6     7   0.598
#> 11 Fisher (1996) Outpatient Drug use    Disease   TAU         6     7   0.219
#> 12 Fisher (1996) Outpatient Drug use    Cognitive TAU         6     7   0.2  
#> 13 Fisher (1996) Outpatient Psych func  Disease   TAU         6     7   0.464
#> 14 Fisher (1996) Outpatient Psych func  Cognitive TAU         6     7   0.476
#> 15 Fisher (1996) Outpatient Social      Disease   TAU         6     7   0.683
#> 16 Fisher (1996) Outpatient Social      Cognitive TAU         6     7   0.584
#>    m_pre_c sd_pre_t sd_pre_c m_post_t m_post_c sd_post_t sd_post_c m_diff_t
#>      <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>     <dbl>    <dbl>
#>  1   0.349     0.12     0.22    0.07     0.141      0.11      0.21    0.399
#>  2   0.349     0.13     0.22    0.018    0.141      0.05      0.21    0.423
#>  3   0.117     0.09     0.12    0.001    0.087      0.01      0.12    0.106
#>  4   0.117     0.1      0.12    0.008    0.087      0.02      0.12    0.108
#>  5   0.605     0.17     0.15    0.319    0.601      0.14      0.18    0.074
#>  6   0.605     0.13     0.15    0.442    0.601      0.16      0.18    0.056
#>  7   0.45      0.21     0.24    0.083    0.489      0.1       0.18    0.259
#>  8   0.45      0.12     0.24    0.103    0.489      0.1       0.18    0.316
#>  9   0.682     0.11     0.17    0.521    0.492      0.11      0.27    0.204
#> 10   0.682     0.16     0.17    0.152    0.492      0.15      0.27    0.446
#> 11   0.322     0.11     0.05    0.167    0.216      0.1       0.15    0.052
#> 12   0.322     0.12     0.05    0.044    0.216      0.05      0.15    0.196
#> 13   0.487     0.14     0.16    0.432    0.472      0.18      0.18    0.032
#> 14   0.487     0.12     0.16    0.232    0.472      0.07      0.18    0.244
#> 15   0.571     0.04     0.09    0.641    0.514      0.06      0.12    0.042
#> 16   0.571     0.05     0.09    0.233    0.514      0.16      0.12    0.351
#>    m_diff_c sd_diff_t sd_diff_c mean_diff_test_t mean_diff_test_c     r_t    r_c
#>       <dbl>     <dbl>     <dbl>            <dbl>            <dbl>   <dbl>  <dbl>
#>  1    0.208      0.02      0.04          0.399           0.208    0.9886  0.9838
#>  2    0.208      0.09      0.04          0.423           0.208    0.8692  0.9838
#>  3    0.03       0.09      0.02          0.106           0.03     0.05556 0.9861
#>  4    0.03       0.09      0.02          0.108           0.03     0.5750  0.9861
#>  5    0.004      0.04      0.04          0.074           0.004000 0.9853  0.9870
#>  6    0.004      0.04      0.04          0.056           0.004000 0.9832  0.9870
#>  7   -0.039      0.13      0.07          0.259          -0.0390   0.8857  0.9850
#>  8   -0.039      0.03      0.07          0.316          -0.0390   0.9792  0.9850
#>  9    0.19       0.01      0.11          0.204           0.19     0.9959  0.9771
#> 10    0.19       0.02      0.11          0.446           0.19     0.9938  0.9771
#> 11    0.106      0.02      0.11          0.052           0.106    0.9864  0.86  
#> 12    0.106      0.08      0.11          0.156           0.106    0.875   0.86  
#> 13    0.015      0.05      0.03          0.03200         0.01500  0.9821  0.9913
#> 14    0.015      0.06      0.03          0.244           0.01500  0.9345  0.9913
#> 15    0.057      0.03      0.04          0.04200         0.05700  0.8958  0.9676
#> 16    0.057      0.12      0.04          0.351           0.05700  0.8562  0.9676
#>        z_t   z_c    v_t   v_c   w_t   w_c treatment main_es_method mean_z  ppcor
#>      <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>     <chr>           <dbl>  <dbl>
#>  1 2.582   2.403 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.943 0.9598
#>  2 1.330   2.403 0.3333  0.25     3     4 Disease   diff-in-diffs   2.480 0.9861
#>  3 0.05561 2.481 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.699 0.9352
#>  4 0.6550  2.481 0.3333  0.25     3     4 Disease   diff-in-diffs   1.442 0.8941
#>  5 2.453   2.516 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.460 0.9855
#>  6 2.385   2.516 0.3333  0.25     3     4 Disease   diff-in-diffs   2.489 0.9863
#>  7 1.402   2.441 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.371 0.9827
#>  8 2.277   2.441 0.3333  0.25     3     4 Disease   diff-in-diffs   1.996 0.9637
#>  9 3.090   2.230 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.509 0.9869
#> 10 2.883   2.230 0.3333  0.25     3     4 Disease   diff-in-diffs   2.598 0.9890
#> 11 2.491   1.293 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.319 0.8666
#> 12 1.354   1.293 0.3333  0.25     3     4 Disease   diff-in-diffs   1.806 0.9475
#> 13 2.355   2.718 0.3333  0.25     3     4 Cognitive diff-in-diffs   2.279 0.9792
#> 14 1.693   2.718 0.3333  0.25     3     4 Disease   diff-in-diffs   2.562 0.9882
#> 15 1.451   2.053 0.3333  0.25     3     4 Cognitive diff-in-diffs   1.721 0.9380
#> 16 1.279   2.053 0.3333  0.25     3     4 Disease   diff-in-diffs   1.795 0.9463
#>    ppcor_calc_method             N_tot df_ind sd_pool m_diff_post  d_post
#>    <chr>                         <dbl>  <dbl>   <dbl>       <dbl>   <dbl>
#>  1 Calculated from study results    13     13 0.1460      0.123    0.8425
#>  2 Calculated from study results    13     13 0.1581      0.071    0.4490
#>  3 Calculated from study results    13     13 0.08246     0.079    0.9580
#>  4 Calculated from study results    13     13 0.08176     0.086    1.052 
#>  5 Calculated from study results    13     13 0.1575      0.159    1.010 
#>  6 Calculated from study results    13     13 0.1500      0.282    1.880 
#>  7 Calculated from study results    13     13 0.1371      0.386    2.815 
#>  8 Calculated from study results    13     13 0.1371      0.406    2.961 
#>  9 Calculated from study results    13     13 0.2057      0.34     1.653 
#> 10 Calculated from study results    13     13 0.1957     -0.02900 -0.1482
#> 11 Calculated from study results    13     13 0.1065      0.172    1.615 
#> 12 Calculated from study results    13     13 0.1193      0.049    0.4108
#> 13 Calculated from study results    13     13 0.1298      0.24     1.850 
#> 14 Calculated from study results    13     13 0.1656      0.0400   0.2416
#> 15 Calculated from study results    13     13 0.1284      0.281    2.188 
#> 16 Calculated from study results    13     13 0.08961    -0.127   -1.417 
#>    vd_post Wd_post      J  g_post vg_post Wg_post sd_control delta_post  diff_t
#>      <dbl>   <dbl>  <dbl>   <dbl>   <dbl>   <dbl>      <dbl>      <dbl>   <dbl>
#>  1  0.3368  0.3095 0.9412  0.7929  0.3368  0.3095       0.21     0.5857 0.423  
#>  2  0.3173  0.3095 0.9412  0.4226  0.3173  0.3095       0.21     0.3381 0.399  
#>  3  0.3448  0.3095 0.9412  0.9017  0.3448  0.3095       0.12     0.6583 0.108  
#>  4  0.3521  0.3095 0.9412  0.9900  0.3521  0.3095       0.12     0.7167 0.106  
#>  5  0.3487  0.3095 0.9412  0.9503  0.3487  0.3095       0.18     0.8833 0.056  
#>  6  0.4455  0.3095 0.9412  1.770   0.4455  0.3095       0.18     1.567  0.074  
#>  7  0.6143  0.3095 0.9412  2.650   0.6143  0.3095       0.18     2.144  0.316  
#>  8  0.6467  0.3095 0.9412  2.787   0.6467  0.3095       0.18     2.256  0.259  
#>  9  0.4146  0.3095 0.9412  1.556   0.4146  0.3095       0.27     1.259  0.446  
#> 10  0.3104  0.3095 0.9412 -0.1395  0.3104  0.3095       0.27    -0.1074 0.204  
#> 11  0.4098  0.3095 0.9412  1.520   0.4098  0.3095       0.15     1.147  0.156  
#> 12  0.3160  0.3095 0.9412  0.3866  0.3160  0.3095       0.15     0.3267 0.052  
#> 13  0.4411  0.3095 0.9412  1.741   0.4411  0.3095       0.18     1.333  0.244  
#> 14  0.3118  0.3095 0.9412  0.2274  0.3118  0.3095       0.18     0.2222 0.03200
#> 15  0.4937  0.3095 0.9412  2.059   0.4937  0.3095       0.12     2.342  0.351  
#> 16  0.3868  0.3095 0.9412 -1.334   0.3868  0.3095       0.12    -1.058  0.04200
#>       diff_c       DD    d_DID   vd_DID sed_DID   Wd_DID    g_DID   vg_DID
#>        <dbl>    <dbl>    <dbl>    <dbl>   <dbl>    <dbl>    <dbl>    <dbl>
#>  1  0.208     0.215    1.473   0.1083   0.3291  0.02490   1.386   0.09879 
#>  2  0.208     0.191    1.208   0.06473  0.2544  0.008626  1.137   0.05833 
#>  3  0.03      0.078    0.9459  0.07450  0.2729  0.04009   0.8902  0.07057 
#>  4  0.03      0.076    0.9296  0.09882  0.3144  0.06558   0.8749  0.09502 
#>  5  0.004000  0.052    0.3302  0.01317  0.1148  0.008975  0.3108  0.01269 
#>  6  0.004000  0.07     0.4667  0.01685  0.1298  0.008471  0.4393  0.01589 
#>  7 -0.0390    0.355    2.589   0.2685   0.5182  0.01071   2.437   0.2391  
#>  8 -0.0390    0.298    2.173   0.2041   0.4518  0.02246   2.046   0.1834  
#>  9  0.19      0.256    1.245   0.06772  0.2602  0.008132  1.171   0.06092 
#> 10  0.19      0.01400  0.07154 0.007011 0.08373 0.006814  0.06733 0.006989
#> 11  0.106     0.05     0.4694  0.09104  0.3017  0.08257   0.4418  0.09007 
#> 12  0.106    -0.054   -0.4527  0.04040  0.2010  0.03252  -0.4260  0.03950 
#> 13  0.01500   0.229    1.765   0.1326   0.3642  0.01286   1.661   0.1190  
#> 14  0.01500   0.01700  0.1027  0.007729 0.08791 0.007323  0.09663 0.007682
#> 15  0.05700   0.294    2.289   0.2399   0.4898  0.03836   2.155   0.2169  
#> 16  0.05700  -0.01500 -0.1674  0.03433  0.1853  0.03326  -0.1575  0.03421 
#>      Wg_DID n_group   icc icc_type gamma_sqrt gamma_sqrt_test     h  omega
#>       <dbl>   <dbl> <dbl> <chr>         <dbl>           <dbl> <dbl>  <dbl>
#>  1 0.02490        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  2 0.008626       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  3 0.04009        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  4 0.06558        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  5 0.008975       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  6 0.008471       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  7 0.01071        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  8 0.02246        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>  9 0.008132       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 10 0.006814       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 11 0.08257        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 12 0.03252        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 13 0.01286        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 14 0.007323       5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 15 0.03836        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#> 16 0.03326        5   0.1 Imputed       0.953          0.9535 10.94 0.9298
#>    gt_post vgt_post Wgt_post   gt_DID  vgt_DID  Wgt_DID  hg_DID vhg_DID h_DID
#>      <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>   <dbl>   <dbl> <dbl>
#>  1  0.7466   0.3873   0.3618  1.305   0.1069   0.02911   1.792  0.09141 10.94
#>  2  0.3979   0.3691   0.3618  1.070   0.06244  0.01008   2.209  0.09141 10.94
#>  3  0.8489   0.3948   0.3618  0.8382  0.07897  0.04686   1.067  0.09141 10.94
#>  4  0.9321   0.4015   0.3618  0.8237  0.1077   0.07667   0.8477 0.09141 10.94
#>  5  0.8947   0.3984   0.3618  0.2926  0.01440  0.01049   0.8174 0.09141 10.94
#>  6  1.666    0.4887   0.3618  0.4136  0.01772  0.009902  1.132  0.09141 10.94
#>  7  2.495    0.6463   0.3618  2.294   0.2531   0.01252   3.088  0.09141 10.94
#>  8  2.624    0.6765   0.3618  1.926   0.1958   0.02626   2.351  0.09141 10.94
#>  9  1.465    0.4599   0.3618  1.103   0.06511  0.009506  2.286  0.09141 10.94
#> 10 -0.1313   0.3626   0.3618  0.06339 0.008150 0.007966  0.2139 0.09141 10.94
#> 11  1.431    0.4554   0.3618  0.4160  0.1044   0.09652   0.3995 0.09141 10.94
#> 12  0.3640   0.3679   0.3618 -0.4011  0.04537  0.03801  -0.6035 0.09141 10.94
#> 13  1.639    0.4846   0.3618  1.564   0.1268   0.01503   2.444  0.09141 10.94
#> 14  0.2141   0.3639   0.3618  0.09098 0.008939 0.008561  0.2951 0.09141 10.94
#> 15  1.939    0.5337   0.3618  2.029   0.2329   0.04485   2.072  0.09141 10.94
#> 16 -1.256    0.4339   0.3618 -0.1483  0.03988  0.03888  -0.2265 0.09141 10.94
#>    df_DID n_covariates_DID adj_fct_DID adj_value_DID gamma_sqrt_005 h_005
#>     <dbl>            <dbl> <chr>               <dbl>          <dbl> <dbl>
#>  1  10.94                1 eta                 1.169          0.977 10.99
#>  2  10.94                1 eta                 1.169          0.977 10.99
#>  3  10.94                1 eta                 1.169          0.977 10.99
#>  4  10.94                1 eta                 1.169          0.977 10.99
#>  5  10.94                1 eta                 1.169          0.977 10.99
#>  6  10.94                1 eta                 1.169          0.977 10.99
#>  7  10.94                1 eta                 1.169          0.977 10.99
#>  8  10.94                1 eta                 1.169          0.977 10.99
#>  9  10.94                1 eta                 1.169          0.977 10.99
#> 10  10.94                1 eta                 1.169          0.977 10.99
#> 11  10.94                1 eta                 1.169          0.977 10.99
#> 12  10.94                1 eta                 1.169          0.977 10.99
#> 13  10.94                1 eta                 1.169          0.977 10.99
#> 14  10.94                1 eta                 1.169          0.977 10.99
#> 15  10.94                1 eta                 1.169          0.977 10.99
#> 16  10.94                1 eta                 1.169          0.977 10.99
#>    omega_005 gt_DID_005 vgt_DID_005 Wgt_DID_005 gamma_sqrt_02  h_02 omega_02
#>        <dbl>      <dbl>       <dbl>       <dbl>         <dbl> <dbl>    <dbl>
#>  1    0.9302    1.338      0.1085      0.02702          0.905 10.71   0.9283
#>  2    0.9302    1.098      0.06417     0.009359         0.905 10.71   0.9283
#>  3    0.9302    0.8596     0.07711     0.04350          0.905 10.71   0.9283
#>  4    0.9302    0.8448     0.1036      0.07116          0.905 10.71   0.9283
#>  5    0.9302    0.3001     0.01383     0.009737         0.905 10.71   0.9283
#>  6    0.9302    0.4242     0.01738     0.009191         0.905 10.71   0.9283
#>  7    0.9302    2.353      0.2635      0.01162          0.905 10.71   0.9283
#>  8    0.9302    1.975      0.2019      0.02437          0.905 10.71   0.9283
#>  9    0.9302    1.131      0.06704     0.008823         0.905 10.71   0.9283
#> 10    0.9302    0.06501    0.007586    0.007394         0.905 10.71   0.9283
#> 11    0.9302    0.4266     0.09786     0.08959          0.905 10.71   0.9283
#> 12    0.9302   -0.4114     0.04298     0.03528          0.905 10.71   0.9283
#> 13    0.9302    1.604      0.1310      0.01395          0.905 10.71   0.9283
#> 14    0.9302    0.09331    0.008342    0.007946         0.905 10.71   0.9283
#> 15    0.9302    2.080      0.2385      0.04162          0.905 10.71   0.9283
#> 16    0.9302   -0.1521     0.03714     0.03608          0.905 10.71   0.9283
#>    gt_DID_02 vgt_DID_02 Wgt_DID_02 vary_id                         
#>        <dbl>      <dbl>      <dbl> <chr>                           
#>  1   1.237     0.1048     0.03332  Inpatient/Alcohol use/Cognitive 
#>  2   1.015     0.05961    0.01154  Inpatient/Alcohol use/Disease   
#>  3   0.7947    0.08312    0.05364  Inpatient/Drug use/Cognitive    
#>  4   0.7809    0.1162     0.08775  Inpatient/Drug use/Disease      
#>  5   0.2774    0.01560    0.01201  Inpatient/Psych func/Cognitive  
#>  6   0.3921    0.01851    0.01133  Inpatient/Psych func/Disease    
#>  7   2.175     0.2352     0.01433  Inpatient/Social/Cognitive      
#>  8   1.826     0.1857     0.03005  Inpatient/Social/Disease        
#>  9   1.046     0.06193    0.01088  Outpatient/Alcohol use/Cognitive
#> 10   0.06010   0.009286   0.009118 Outpatient/Alcohol use/Disease  
#> 11   0.3943    0.1177     0.1105   Outpatient/Drug use/Cognitive   
#> 12  -0.3803    0.05026    0.04351  Outpatient/Drug use/Disease     
#> 13   1.483     0.1198     0.01720  Outpatient/Psych func/Cognitive 
#> 14   0.08626   0.01015    0.009798 Outpatient/Psych func/Disease   
#> 15   1.923     0.2240     0.05133  Outpatient/Social/Cognitive     
#> 16  -0.1406    0.04542    0.04450  Outpatient/Social/Disease
```

### Konstruktion af varians-covarians matrix når man har mere end en treatment (og/eller kontrol) gruppe

``` r

V_dat_test <- 
  Fisher1996_es |> 
  #dplyr::filter(setting == "Inpatient") |> 
  metafor::escalc(measure="SMD", yi = g_DID, vi = vg_DID, data = _) |> 
  mutate(esid = 1:n())

V_vcalc <- 
  metafor::vcalc(
    data = V_dat_test,
    vi = vi, 
    cluster = study,
    subgroup = setting,
    obs = outcome, 
    grp1 = group_t,
    w1 = N_t, 
    grp2 = group_c,
    w2 = N_c,
    rho = 0.7, 
    sparse = TRUE
  )

V_vcalc |> as.matrix() |> as.data.frame()
#>            V1          V2         V3         V4          V5          V6
#> 1  0.09878727 0.035034135 0.05844718 0.03130179 0.024783717 0.012801364
#> 2  0.03503413 0.058326513 0.02072784 0.05211272 0.008789352 0.021312326
#> 3  0.05844718 0.020727838 0.07057162 0.03779511 0.020947442 0.010819839
#> 4  0.03130179 0.052112719 0.03779511 0.09502226 0.011218545 0.027202607
#> 5  0.02478372 0.008789352 0.02094744 0.01121854 0.012689246 0.006554289
#> 6  0.01280136 0.021312326 0.01081984 0.02720261 0.006554289 0.015892771
#> 7  0.10758047 0.038152575 0.09092808 0.04869715 0.038556789 0.019915475
#> 8  0.04348578 0.072397216 0.03675461 0.09240629 0.015585282 0.037791025
#> 9  0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 10 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 11 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 12 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 13 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 14 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 15 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#> 16 0.00000000 0.000000000 0.00000000 0.00000000 0.000000000 0.000000000
#>            V7         V8          V9         V10         V11        V12
#> 1  0.10758047 0.04348578 0.000000000 0.000000000 0.000000000 0.00000000
#> 2  0.03815258 0.07239722 0.000000000 0.000000000 0.000000000 0.00000000
#> 3  0.09092808 0.03675461 0.000000000 0.000000000 0.000000000 0.00000000
#> 4  0.04869715 0.09240629 0.000000000 0.000000000 0.000000000 0.00000000
#> 5  0.03855679 0.01558528 0.000000000 0.000000000 0.000000000 0.00000000
#> 6  0.01991547 0.03779103 0.000000000 0.000000000 0.000000000 0.00000000
#> 7  0.23909463 0.09664594 0.000000000 0.000000000 0.000000000 0.00000000
#> 8  0.09664594 0.18339253 0.000000000 0.000000000 0.000000000 0.00000000
#> 9  0.00000000 0.00000000 0.060916367 0.009523074 0.051851916 0.01584747
#> 10 0.00000000 0.00000000 0.009523074 0.006988831 0.008106026 0.01163020
#> 11 0.00000000 0.00000000 0.051851916 0.008106026 0.090074018 0.02752927
#> 12 0.00000000 0.00000000 0.015847470 0.011630203 0.027529268 0.03949790
#> 13 0.00000000 0.00000000 0.059589219 0.009315601 0.072460356 0.02214601
#> 14 0.00000000 0.00000000 0.006989072 0.005129168 0.008498696 0.01219359
#> 15 0.00000000 0.00000000 0.080466733 0.012579389 0.097847366 0.02990503
#> 16 0.00000000 0.00000000 0.014748754 0.010823874 0.017934451 0.02573164
#>            V13         V14        V15        V16
#> 1  0.000000000 0.000000000 0.00000000 0.00000000
#> 2  0.000000000 0.000000000 0.00000000 0.00000000
#> 3  0.000000000 0.000000000 0.00000000 0.00000000
#> 4  0.000000000 0.000000000 0.00000000 0.00000000
#> 5  0.000000000 0.000000000 0.00000000 0.00000000
#> 6  0.000000000 0.000000000 0.00000000 0.00000000
#> 7  0.000000000 0.000000000 0.00000000 0.00000000
#> 8  0.000000000 0.000000000 0.00000000 0.00000000
#> 9  0.059589219 0.006989072 0.08046673 0.01474875
#> 10 0.009315601 0.005129168 0.01257939 0.01082387
#> 11 0.072460356 0.008498696 0.09784737 0.01793445
#> 12 0.022146015 0.012193591 0.02990503 0.02573164
#> 13 0.118961192 0.013952664 0.11244808 0.02061062
#> 14 0.013952664 0.007682334 0.01318876 0.01134820
#> 15 0.112448075 0.013188757 0.21692153 0.03975956
#> 16 0.020610617 0.011348201 0.03975956 0.03421092
V_vcalc |> cov2cor()
#> 16 x 16 sparse Matrix of class "dsCMatrix"
#>                                                                            
#>  [1,] 1.0000000 0.4615385 0.7000000 0.3230769 0.7000000 0.3230769 0.7000000
#>  [2,] 0.4615385 1.0000000 0.3230769 0.7000000 0.3230769 0.7000000 0.3230769
#>  [3,] 0.7000000 0.3230769 1.0000000 0.4615385 0.7000000 0.3230769 0.7000000
#>  [4,] 0.3230769 0.7000000 0.4615385 1.0000000 0.3230769 0.7000000 0.3230769
#>  [5,] 0.7000000 0.3230769 0.7000000 0.3230769 1.0000000 0.4615385 0.7000000
#>  [6,] 0.3230769 0.7000000 0.3230769 0.7000000 0.4615385 1.0000000 0.3230769
#>  [7,] 0.7000000 0.3230769 0.7000000 0.3230769 0.7000000 0.3230769 1.0000000
#>  [8,] 0.3230769 0.7000000 0.3230769 0.7000000 0.3230769 0.7000000 0.4615385
#>  [9,] .         .         .         .         .         .         .        
#> [10,] .         .         .         .         .         .         .        
#> [11,] .         .         .         .         .         .         .        
#> [12,] .         .         .         .         .         .         .        
#> [13,] .         .         .         .         .         .         .        
#> [14,] .         .         .         .         .         .         .        
#> [15,] .         .         .         .         .         .         .        
#> [16,] .         .         .         .         .         .         .        
#>                                                                            
#>  [1,] 0.3230769 .         .         .         .         .         .        
#>  [2,] 0.7000000 .         .         .         .         .         .        
#>  [3,] 0.3230769 .         .         .         .         .         .        
#>  [4,] 0.7000000 .         .         .         .         .         .        
#>  [5,] 0.3230769 .         .         .         .         .         .        
#>  [6,] 0.7000000 .         .         .         .         .         .        
#>  [7,] 0.4615385 .         .         .         .         .         .        
#>  [8,] 1.0000000 .         .         .         .         .         .        
#>  [9,] .         1.0000000 0.4615385 0.7000000 0.3230769 0.7000000 0.3230769
#> [10,] .         0.4615385 1.0000000 0.3230769 0.7000000 0.3230769 0.7000000
#> [11,] .         0.7000000 0.3230769 1.0000000 0.4615385 0.7000000 0.3230769
#> [12,] .         0.3230769 0.7000000 0.4615385 1.0000000 0.3230769 0.7000000
#> [13,] .         0.7000000 0.3230769 0.7000000 0.3230769 1.0000000 0.4615385
#> [14,] .         0.3230769 0.7000000 0.3230769 0.7000000 0.4615385 1.0000000
#> [15,] .         0.7000000 0.3230769 0.7000000 0.3230769 0.7000000 0.3230769
#> [16,] .         0.3230769 0.7000000 0.3230769 0.7000000 0.3230769 0.7000000
#>                          
#>  [1,] .         .        
#>  [2,] .         .        
#>  [3,] .         .        
#>  [4,] .         .        
#>  [5,] .         .        
#>  [6,] .         .        
#>  [7,] .         .        
#>  [8,] .         .        
#>  [9,] 0.7000000 0.3230769
#> [10,] 0.3230769 0.7000000
#> [11,] 0.7000000 0.3230769
#> [12,] 0.3230769 0.7000000
#> [13,] 0.7000000 0.3230769
#> [14,] 0.3230769 0.7000000
#> [15,] 1.0000000 0.4615385
#> [16,] 0.4615385 1.0000000
  
# Assuming constant correlation

V_vcalc_constant <- 
  metafor::vcalc(
    data = V_dat_test,
    vi = vi, 
    cluster = study,
    obs = esid, 
    rho = 0.7, 
    sparse = TRUE
  )

V_vcalc_constant
#> 16 x 16 sparse Matrix of class "dgCMatrix"
#>                                                                          
#>  [1,] 0.09878727 0.05313510 0.05844718 0.06782054 0.024783717 0.027736288
#>  [2,] 0.05313510 0.05832651 0.04491031 0.05211272 0.019043596 0.021312326
#>  [3,] 0.05844718 0.04491031 0.07057162 0.05732259 0.020947442 0.023442985
#>  [4,] 0.06782054 0.05211272 0.05732259 0.09502226 0.024306847 0.027202607
#>  [5,] 0.02478372 0.01904360 0.02094744 0.02430685 0.012689246 0.009940672
#>  [6,] 0.02773629 0.02131233 0.02344298 0.02720261 0.009940672 0.015892771
#>  [7,] 0.10758047 0.08266391 0.09092808 0.10551049 0.038556789 0.043150195
#>  [8,] 0.09421919 0.07239722 0.07963499 0.09240629 0.033768111 0.037791025
#>  [9,] 0.05430196 0.04172516 0.04589656 0.05325713 0.019461797 0.021780350
#> [10,] 0.01839293 0.01413297 0.01554588 0.01803902 0.006592016 0.007377346
#> [11,] 0.06603106 0.05073770 0.05581011 0.06476054 0.023665502 0.026484856
#> [12,] 0.04372557 0.03359836 0.03695729 0.04288424 0.015671225 0.017538193
#> [13,] 0.07588417 0.05830875 0.06413805 0.07442406 0.027196850 0.030436906
#> [14,] 0.01928391 0.01481759 0.01629895 0.01891286 0.006911344 0.007734717
#> [15,] 0.10247074 0.07873764 0.08660928 0.10049907 0.036725463 0.041100697
#> [16,] 0.04069405 0.03126896 0.03439501 0.03991105 0.014584728 0.016322258
#>                                                                         
#>  [1,] 0.10758047 0.09421919 0.05430196 0.018392926 0.06603106 0.04372557
#>  [2,] 0.08266391 0.07239722 0.04172516 0.014132966 0.05073770 0.03359836
#>  [3,] 0.09092808 0.07963499 0.04589656 0.015545882 0.05581011 0.03695729
#>  [4,] 0.10551049 0.09240629 0.05325713 0.018039023 0.06476054 0.04288424
#>  [5,] 0.03855679 0.03376811 0.01946180 0.006592016 0.02366550 0.01567122
#>  [6,] 0.04315019 0.03779103 0.02178035 0.007377346 0.02648486 0.01753819
#>  [7,] 0.23909463 0.14657968 0.08447923 0.028614439 0.10272655 0.06802522
#>  [8,] 0.14657968 0.18339253 0.07398708 0.025060581 0.08996812 0.05957662
#>  [9,] 0.08447923 0.07398708 0.06091637 0.014443329 0.05185192 0.03433618
#> [10,] 0.02861444 0.02506058 0.01444333 0.006988831 0.01756306 0.01163020
#> [11,] 0.10272655 0.08996812 0.05185192 0.017563056 0.09007402 0.04175272
#> [12,] 0.06802522 0.05957662 0.03433618 0.011630203 0.04175272 0.03949790
#> [13,] 0.11805533 0.10339309 0.05958922 0.020183802 0.07246036 0.04798303
#> [14,] 0.03000057 0.02627456 0.01514299 0.005129168 0.01841384 0.01219359
#> [15,] 0.15941687 0.13961761 0.08046673 0.027255343 0.09784737 0.06479423
#> [16,] 0.06330898 0.05544613 0.03195563 0.010823874 0.03885798 0.02573164
#>                                                   
#>  [1,] 0.07588417 0.019283911 0.10247074 0.04069405
#>  [2,] 0.05830875 0.014817592 0.07873764 0.03126896
#>  [3,] 0.06413805 0.016298952 0.08660928 0.03439501
#>  [4,] 0.07442406 0.018912865 0.10049907 0.03991105
#>  [5,] 0.02719685 0.006911344 0.03672546 0.01458473
#>  [6,] 0.03043691 0.007734717 0.04110070 0.01632226
#>  [7,] 0.11805533 0.030000572 0.15941687 0.06330898
#>  [8,] 0.10339309 0.026274560 0.13961761 0.05544613
#>  [9,] 0.05958922 0.015142990 0.08046673 0.03195563
#> [10,] 0.02018380 0.005129168 0.02725534 0.01082387
#> [11,] 0.07246036 0.018413841 0.09784737 0.03885798
#> [12,] 0.04798303 0.012193591 0.06479423 0.02573164
#> [13,] 0.11896119 0.021161541 0.11244808 0.04465634
#> [14,] 0.02116154 0.007682334 0.02857564 0.01134820
#> [15,] 0.11244808 0.028575640 0.21692153 0.06030201
#> [16,] 0.04465634 0.011348201 0.06030201 0.03421092
V_vcalc_constant |> cov2cor()
#> 16 x 16 sparse Matrix of class "dsCMatrix"
#>                                                                      
#>  [1,] 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [2,] 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [3,] 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [4,] 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [5,] 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [6,] 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [7,] 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [8,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#>  [9,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7 0.7
#> [10,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7 0.7
#> [11,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7 0.7
#> [12,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7 0.7
#> [13,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7 0.7
#> [14,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7 0.7
#> [15,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0 0.7
#> [16,] 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 1.0
```

### Long and wide format data

Begge formater har hver deres ulemper. Man skal skrive mindre kode, når
man beregner effektstørrelser med long format data, men man har dermed
også et datasæt som i antal af rækker ikke passer sammen med den
endelige effektstørrelsesdata. Omvendt, kræver det længere koder at kode
wide format data, men her får man tilgengæld også et datasæt som passer
i antal med dette endelige effektstørrelses datasæt. På mange af vores
andre review indtastes den raw data (som den fra Tabel 1) direkte i
excel i stedet for i R. Det kan igen måde have fordele og ulemper. Ved
at indtaste det studie for studie i R, bliver det noget tydeligere for
læsere, hvor man præcist har udtrykket data, men det kræver også at man
skriver langt, langt flere koder, som på mange måder kan være meget
tidskrævende. Igen det er meget en smagssag.

``` r

pivot_wider(
  Fisher1996,
  values_from = m_pre:v,
  names_from = treatment
  )
```

## Visualize effect size data

``` r

Fisher1996_est |> 
  tidyr::pivot_longer(
    cols = -c(study:diff_c, J),
    names_to = c('.value', 'Category'), 
    names_sep = '_'
  ) |> 
  mutate(
    CI_L = es - se * qnorm(.975),
    CI_U = es + se * qnorm(.975)
  ) |> 
  filter(treatment == "Cognitive") |> 
  ggplot(aes(x = es, y = Category, xmin = CI_L, xmax = CI_U,
        color = Category)) + 
  geom_pointrange(position = position_dodge2(width = 0.5, padding = 0.5)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = 0.5) +
  facet_grid(setting~outcome, scales = "free") +
  theme_bw() +
  theme(legend.position = "bottom") +
  ylab("Effect size type")
  
```

## References

Fisher, M. S, and K. J Bentley. 1996. “Two group therapy models for
clients with a dual diagnosis of substance abuse and personality
disorder.” *Psychiatric Services (Washington, D.C.)* 47 (11): 1244–50.
<https://doi.org/10.1176/ps.47.11.1244>.

------------------------------------------------------------------------

1.  Det vigtigt here at sige her, at Tabel 1 kunne bruges som et fiktivt
    eksempel, så man kan ikke drage nogen substantielle fortolkninger af
    denne blog. Tabel 1 er udelukkende konstrueret for eksempels skyld.
