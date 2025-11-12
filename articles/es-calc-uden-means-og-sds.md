# Effektstørrelsesudregning uden means og SDs (med eksempler)

**Vigtig note**

Bemærk, nedenstående er kun ét eksempel på, hvordan man kan bakke
sampling variansen ud fra anden information end sample sizes. Nogle
studier vil afrapportere anderledes, og der vil man skulle gøre andre
ting. Over tid vil jeg forsøge at samle så mange eksempler på bloggen
her som muligt.

  

Et typisk problem vi møder, når vi skal meta-analysere effekt-studier,
er, at forfatterne ikke afrapporterer de kvantitative mål, som vi skal
bruge ift. at kunne beregne effektstørrelser, oftest vi det være
manglende afrapportering af rå gennemsnit (raw means) og de tilhørende
standardafvigelser (SDs). Heldigvis findes der dog en række ‘hacks’, som
kan overkomme nogle af disse problemer. I denne vignette vil jeg vise
nogle eksempler på, hvordan vi kan løse disse udfordringer. Første
eksempel tager udgangspunkt i Michalak et
al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html)), der
afrapporter means og SDs på baseline og posttest niveau for to typer af
outcomes (HAM-D og BDI, se Tabel 2, s. 957), og beta-coefficienter,
standard error (SE) fra en fixed-effects multi-level model samt
effektstørrelser for to andre outcomes (dvs. SF-36 og SASS, se Tabel 5,
s. 959). I eksemplerne herunder vil jeg også vise, hvordan
effektstørrelser sammenlægges, hvis disse afrapporteres på sub-skalaer,
der ikke er relevante for en meta-analys’ moderator-analyser.  
  

## **Eksempel 1 - Michalak et al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html))**

### Hvad gør vi når vi ikke kender pre-posttest korrelationen?

Lad os starte udregne effektstørrelser baseret på HAM-D og BDI målene
fra Michalak et
al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html)). I og
med at forfatterne afrapporterer raw means både på baseline og posttest
niveau, så kan vi i teorien både beregne en ren posttest-baseret
effektstørrelse og/eller baseline/pretest adjusted effektstørrelse (kald
det hvad I vil – jeg kalder den også nogen gange for en
diffencence-in-differences effektstørrelse \[DID\]), hvor vi
kontrollerer for eventuelle baseline forskelle mellem grupperne. Vi vil
ofte beregne begge, men jeg er ret stor fan af den baseline-adjusted
effektstørrelse, dels fordi denne kan reducere bias og dels fordi den
kan estimateres mere præcist (se Hedges et
al. [2023](https://doi.org/10.1111/bmsp.12296)). Formlen for DID
effektstørrelsen, som kan beregne ud fra Tabel 2 i Michalak et
al. (2015), er givet ved

  

\\\begin{equation} \tag{1} g\_{DID} = J \left(\frac{\[M^T\_{post} -
M^T\_{baseline}\] - \[M^C\_{post} -
M^C\_{baseline}\]}{SD\_{pool}}\right) \end{equation}\\  
hvor \\M^T\_{post}\\ og \\M^C\_{post}\\ samt \\M^T\_{baseline}\\ og
\\M^C\_{baseline}\\ er post- og baselinemål for hhv. treatment og
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

  
\\\begin{equation} \tag{2} Var\_{g\_{DID}} = \left(\frac{1}{n^T} +
\frac{1}{n^C}\right) 2(1-\rho\_{prepost}) + \frac{g\_{DID}^2}{2df}
\end{equation}\\  

Problemet er dog, at man skal kende pre-posttest korrelationen,
\\\rho\_{prepost}\\, for at kunne beregne variansen korrekt. I mange
tilfælde vil vi være i stand til at kunne beregne denne. Se eksemplvis
formlerne fra [Cochranes
handbook](https://training.cochrane.org/handbook/current/chapter-06#section-6-5-2-8)
eller formel 31 i Wilson
([2016](https://mason.gmu.edu/~dwilsonb/downloads/esformulas.pdf)). Se
også denne blog på [VIVECampbell
siden](https://mikkelvembye.github.io/VIVECampbell/articles/ancova-puzzler.html).
Alternativt kan \\Var\_{g\_{DID}}\\ beregnes korrekt, hvis forfatterne
har afrapporteret \\t\\- eller \\F\\-værdier fra repeated ANOVA, ANCOVA
eller en regressions model, som har inkluderet baseline outcome som
kontrol variabel. Hvis dette er tilfældet, så

  
\\\begin{equation} \tag{3} Var\_{g\_{DID}} = \frac{g\_{DID}^2}{t^2} +
\frac{g\_{DID}^2}{2df} \end{equation}\\  

Bemærk her at \\F = t^2\\. Se [James Pustejovskys
blog](https://www.jepusto.com/alternative-formulas-for-the-smd/) for en
yderligere uddybning.  

I Michalak et
al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html)) har
vi imidlertidig det problem, at forfatterne ikke afrapporterer nogle af
den kvantitative mål, som vi har brug for, for at kunne beregne
\\Var\_{g\_{DID}}\\ korrekt. I sådan en situation foreslår Hedges et
al. (2023, s. 14) følgende:  

> *To impute a value of the pre-test post-test correlation,
> practitioners could use the test–retest reliability coefficient of the
> outcome measure in the primary study. The test-retest reliability
> coefficient measures the stability of scores across time by computing
> the correlation between a baseline or ‘pre-test’ administration of the
> instrument and then a ‘post-test’ administration of the same
> instrument after a fixed period of time.*

For Michalak et
al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html)) kunne
vi derfor beregnes formel (2) ved at imputere det mest konservative
test-retest reliablity for Hamilton Rating Scale for Depression fundet i
Trajković et
al. ([2011](https://doi.org/10.1016/j.psychres.2010.12.007)), dvs.
\\0.65\\.

``` r
library(dplyr)
library(tibble)

# Dataudtræk
Michalak2015_dat <- 
  tibble(
    outcome = "HAM-D",
    N_t = 36,
    N_c = 35,
    N_total = N_t + N_c, 
    m_pre_t = 23.03,
    sd_pre_t = 6.27,
    m_pre_c = 23.87,
    sd_pre_c = 6.33,
    m_post_t = 17.86,
    sd_post_t = 10.37,
    m_post_c = 21.16,
    sd_post_c = 8.16
    
  )


pp_cor <- 0.65

# Udregning af DID effektstørrelse
Michalak2015_est1 <-
  Michalak2015_dat |> 
  mutate(
    diff_t = m_post_t - m_pre_t,
    diff_c = m_post_c - m_pre_c,
    mean_diff = diff_t - diff_c,
    sd_pool = sqrt( ((N_t-1)*sd_post_t^2 + (N_c-1)*sd_post_c^2)/(N_total-2)  ),
  
    df = N_total,
    
    J = 1 - 3/(4*df-1),
    
    # Formel 1
    g_DD = J * (mean_diff/sd_pool),
    
    # Formel 2 - med imputeret pre-posttest korrelation baseret på test-retest reliability for HAM-D
    vg_DD = (1/N_t + 1/N_c) * 2*(1-pp_cor) + g_DD^2/(2*df),
    se_DD = sqrt(vg_DD)
    
  ) 

# Resultater
Michalak2015_est1 |> 
  select(J:se_DD)
#> # A tibble: 1 × 4
#>        J    g_DD   vg_DD  se_DD
#>    <dbl>   <dbl>   <dbl>  <dbl>
#> 1 0.9894 -0.2604 0.03992 0.1998
```

  
I nogen tilfælde vil det ikke være muligt at kunne finde en beregnet
test-retest reliability. I disse tilfælde, foreslår WWC
([2021](https://ies.ed.gov/ncee/WWC/Docs/referenceresources/WWC-Procedures-Handbook-v4-1-508.pdf),
s. E-6) at imputere \\\rho\_{prepost} = 0.5\\, således at

  
\\\begin{equation} \tag{4} \left(\frac{1}{n^T} + \frac{1}{n^C}\right)
2(1-\rho\_{prepost}) + \frac{g^2}{2df} = \left(\frac{1}{n^T} +
\frac{1}{n^C}\right) + \frac{g^2}{2df} \end{equation}\\  

Formlen på højre side af lighedstegnet i formel 4, svarer til sampling
variansen for den simple posttest effektstørrelse. Det følger at når
\\\rho\_{prepost} \> 0.5\\ så vil højre side af lighedstegnet
overestimere (dvs. variansen vil blive større end forventet) sampling
variansen af \\g\_{DID}\\, mens når \\\rho\_{prepost} \< 0.5\\ vil din
underestimere (det vil modsat sige at variansen vil blive mindre end
forventet) sampling variansen af \\g\_{DID}\\. Hvis man vælger denne
løsning, kan man plot ændre til `pp_cor <- 0.5` i ovenstående koder.

### Effektstørrelsesudregning med beta-coefficient, standardfejl, og afrapportet effekstørrelse

Nu vender vi os imod eksemplet, hvor vi ønsker at udtrække
effektstørrelser og beregne variansen for effektstørrelser, der ikke er
afrapporteret via means og SDs. I Michalak et
al. ([2015](https://psycnet.apa.org/fulltext/2015-36864-001.html))
afrapporteres beta-coefficienter, deres standardfejl, og
effektstørrelser fra en fixed-effect multi-level model, se Tabel 5. I
dette tilfælde må vi stole på forfatternes effektstørrelsesudregning og
trække deres effektstørrelser ud direkte. Der er ikke så meget mere vi
kan gøre her, når ikke forfatterne giver raw means og SDs. Man kunne
evt. skrive til forfatterne og spørge efter disse, hvis man vil, men som
udgangspunkt stoler vi på de afrapporterede effektstørrelser.
Spørgsmålet er nu, hvordan beregner vi sampling variansen for disse
effektstørrelser? Problemet er, at hvis vi benytter formlen på højre
side af lighedstegnet i formel (4), som primært baserer variansen på
sample størrelser, så vil variansen med stor sandsyndlighed ikke blive
beregnet korrekt. Men fordi forfatterne afrapporterer
beta-coefficienter, som basically er en adjusteret means difference
mellem treatment og kontrolgruppen, og standardfejl, så kan vi beregne
\\t = \frac{\beta}{se\_{\beta}}\\ og benytte formel (3) til at udregne
den korrekte sampling varians af de afrapporterede effektstørrelser. Det
kan gøres således

  

``` r

Michalak2015_est2 <- 
  tibble(
    
    outcome = rep(c("SF-36", "SASS"), c(4,1)),
    subscale = c("Vitality", "Social func", "Role", "Mental health", "overall"),
    treatment = "MBCT",
    N_t = 36,
    N_c = 35, 
    N_total = N_t + N_c, 
    df = N_total,
    beta = c(1.12, 0.27, 0.52, 0.63, 2.43),
    se_b = c(0.90, 0.43, 0.26, 0.95, 1.01),
    t_val = beta/se_b,
    d_paper = c(0.31, 0.12, 0.48, 0.14, 0.57),
    J = 1 - 3/(4*df-1),
    g_paper = J * d_paper,
    #vg_post = (1/N_t + 1/N_c) + g_paper^2/(2*df),
    vg_paper = g_paper^2/t_val^2 + g_paper^2/(2*df),
    seg_paper = sqrt(vg_paper)
    
  ); Michalak2015_est2
#> # A tibble: 5 × 15
#>   outcome subscale      treatment   N_t   N_c N_total    df  beta  se_b  t_val
#>   <chr>   <chr>         <chr>     <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl>  <dbl>
#> 1 SF-36   Vitality      MBCT         36    35      71    71  1.12  0.9  1.244 
#> 2 SF-36   Social func   MBCT         36    35      71    71  0.27  0.43 0.6279
#> 3 SF-36   Role          MBCT         36    35      71    71  0.52  0.26 2     
#> 4 SF-36   Mental health MBCT         36    35      71    71  0.63  0.95 0.6632
#> 5 SASS    overall       MBCT         36    35      71    71  2.43  1.01 2.406 
#>   d_paper      J g_paper vg_paper seg_paper
#>     <dbl>  <dbl>   <dbl>    <dbl>     <dbl>
#> 1    0.31 0.9894  0.3067  0.06141    0.2478
#> 2    0.12 0.9894  0.1187  0.03585    0.1893
#> 3    0.48 0.9894  0.4749  0.05797    0.2408
#> 4    0.14 0.9894  0.1385  0.04376    0.2092
#> 5    0.57 0.9894  0.5640  0.05718    0.2391
```

  
I dette studie afrapporteres SF-36 skalaen på tværs af dens subskalaer,
som ikke er relevante for de moderator analyser som var planlagt i dette
givne review (se Dalgaard et
al. [2022](https://onlinelibrary.wiley.com/doi/10.1002/cl2.1254)).
Nedenfor viser jeg, hvordan man kan sammenlægge alle effektstørrelser på
tværs af subskalaer for at få et overordnet mål of SF-36 outcomet. For
at kunne få helt præcise effekter skal man kende mellem-subskala
korrelationerne \\\rho\_{SS}\\. Disse kender vi ikke, men vi antager
her, at korrelationen er meget høj \\\rho\_{SS} = 0.9\\. En rå
sammenlægning uden at imputere \\\rho\_{SS}\\ vil svare til at antage at
\\\rho\_{SS} = 1\\. Om man antager \\\rho\_{SS} = 0.9\\ eller
\\\rho\_{SS} = 1\\, gør med stor sandsynlighed ikke den store forskel,
men her vælger vi at antage \\\rho\_{SS} = 0.9\\. Sammenlægningen kan
gøres således

``` r
library(metafor)

rho <- 0.9

#_agg for aggregated
Michalak2015_metafor <- 
  Michalak2015_est2 |> 
  metafor::escalc(measure = "SMD", yi = g_paper, vi = vg_paper, data = _)

Michalak2015_agg <- 
  aggregate.escalc(Michalak2015_metafor, cluster=outcome, rho=rho) |> 
  as_tibble() |> 
  mutate(
    g_paper = yi, 
    vg_paper = vi, 
    seg_paper = sqrt(vi)
  ) |> 
  # Her fjerner jeg de variabler vi ikke længere kan bruge, da en sammenlægning 
  # af disse ikke giver mening- Og så fjerne jeg yi og vi, som har fået andet navn
  select(-c(subscale, beta:J, yi:vi))

Michalak2015_agg
#> # A tibble: 2 × 9
#>   outcome treatment   N_t   N_c N_total    df  g_paper vg_paper seg_paper
#>   <chr>   <chr>     <dbl> <dbl>   <dbl> <dbl>    <dbl>    <dbl>     <dbl>
#> 1 SF-36   MBCT         36    35      71    71 -0.09513  0.03068    0.1751
#> 2 SASS    MBCT         36    35      71    71  0.5640   0.05718    0.2391
```

Skriv endelig, hvis I har flere problemer, som jeg skal vise løsninger
på.

### Litteratur

Hedges, L. V., & Citkowicz, M. (2015). Estimating effect size when there
is clustering in one treatment group. *Behavior Research Methods*,
47(4), 1295–1308. <https://doi.org/10.3758/s13428-014-0538-z>

Hedges, L. V, Tipton, E., Zejnullahi, R., & Diaz, K. G. (2023). Effect
sizes in ANCOVA and difference-in-differences designs. *British Journal
of Mathematical and Statistical Psychology.*
<https://doi.org/10.1111/bmsp.12296>

Michalak, J., Schultze, M., Heidenreich, T., & Schramm, E. (2015). A
randomized controlled trial on the efficacy of mindfulness-based
cognitive therapy and a group version of cognitive behavioral analysis
system of psychotherapy for chronically depressed patients. *Journal of
Consulting and Clinical Psychology*, 83(5), 951.
<https://doi.org/10.1037/ccp0000042>

Trajković, G., Starčević, V., Latas, M., Leštarević, M., Ille, T.,
Bukumirić, Z., & Marinković, J. (2011). Reliability of the Hamilton
Rating Scale for Depression: A meta-analysis over a period of 49years.
*Psychiatry Research*, 189(1), 1–9.
<https://doi.org/https://doi.org/10.1016/j.psychres.2010.12.007>

WWC. (2021). Supplement document for Appendix E and the What Works
Clearinghouse procedures handbook, version 4.1. *Institute of Education
Sciences*.
<https://ies.ed.gov/ncee/wwc/Docs/referenceresources/WWC-41-Supplement-508_09212020.pdf>

Wilson, D. B. (2016). *Formulas used by the “Practical Meta-Analysis
Effect Size Calculator.*
<https://mason.gmu.edu/~dwilsonb/downloads/esformulas.pdf>
