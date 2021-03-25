#' ---
#' title: "Hjemmeoppgave"
#' author: "Ove Haugland Jakobsen"
#' date: "`r format(Sys.Date(), '%d. %B %Y')`"
#' ---
#' 
#' Vi har allerede hentet inn objektet `nokeur_df` og gjort det tilgjengelig via `hjemmeoppgave.RData`. Hvis du vil hente det inn på egenhånd, kan du kjøre koden under:

nokeur_df <- read.csv2(paste0(
  'https://data.norges-bank.no/api/data/EXR/M.EUR.NOK.SP?format=csv&apisrc=nbi',
  '&startPeriod=2011-01-01&endPeriod=2020-12-01&locale=no'))
nokeur_df <- nokeur_df[, c('TIME_PERIOD', 'OBS_VALUE')]
colnames(nokeur_df) <- c('Tid', 'Verdi')

#' # Oppgaver
#'
#' 1. Hvilken _klasse_ har objektet `nokeur_df`?
#' 2. Hvor mange rader er det i `nokeur_df`?
#' 3. Hva er maksmium verdien i `nokeur_df$Verdi`?
#' 4. Hva er minimum verdien i `nokeur_df$Verdi`?
#' 5. _Hvilken_ observasjon av `nokeur_df$Verdi` har minst verdi?
#'
#' Opprett en vektor `kurs_1` som inneholder første til nest siste verdi i `nokeur_df$Verdi`. Opprett en vektor `kurs_2` som inneholder andre til siste verdi i `nokeur_df$Verdi`
#'
#' 6. Opprett en ny vektor `kurs_endring` som har verdien `"Opp"` hvis `kurs_2` er **større enn** `kurs_1` og verdien `"Ned"` hvis ikke
#' 7. Hvor mange ganger går verdien **opp**?
#' 8. Hvor mange ganger går verdien **ned**?
#'
#' Bruk `plot` til å lage et linjediagram med kursen over tid. Husk at du kan få opp informasjon om `plot` med `?plot` og du kan få listet argumentene til `plot` med `args(plot)`. Du får linjediagram med å sette argumentet `type` til `l`.
#' 
#' Denne oppgaven kan være litt vanskelig, for datasettet er ikke umiddelbart godt tilrettelagt for å analysere data over _tid_. I kurset har vi sett at du kan endre datatyper i R med flere funksjoner som starter med `as.*`, for eksempel ved å endre `character` til `numeric` med `as.numeric("10")`. R har en funksjon for å endre datatype til _dato_ som heter `as.Date()`. Denne forventer en vektor av type `character` som input, og forstår som standard datoformatet `YYYY-MM-DD`. Funksjonen `paste()` slår sammen tekst i R.

x <- 'hello'
y <- 'world'
print(paste(x, y))

#' Vi kan styre hvilket tegn som skiller tekststrengene vi slår sammen med argumentet `sep` (standardverdi er mellomrom):

print(paste(x, y, sep = '-'))

#' 9. Hvordan har kursen utviklet seg over tid?
#' 
#' ## Løsningsforslag
#' 
#' 1. Vi finner klassen til et element med funksjonen `class`.
class(nokeur_df)

#' 2. For å få ut antall rader til et objekt av typen `data.frame`, kan vi bruke funksjonen `nrow`. Det er også mulig å bruke funksjonen `dim` som gir oss dimensjonene i antall rader og kolonner, og så hente ut det første elementet.
nrow(nokeur_df)    # antall rader direkte
dim(nokeur_df)[1]  # første element er antall rader

#' 3. Vi finner den _største verdien_ av `nokeur_df$Verdi` med funsjonen `max`
max(nokeur_df$Verdi)

#' 4. Og den _minste verdien_ med funsjonen `min`
min(nokeur_df$Verdi)

#' 5. For å finne hvilken _observasjon_ (teknisk: hvilket indeksnummer) av `nokeur_df$Verdi` som har den minste verdien, kan vi bruke funksjonen `which.min`. Merk at `which.min` vil returnere en vektor med lengde 1. Hvis det er flere verdier med lik verdi, noe som fort kan skje med verdier på ordinalnivå, og vi ønsker å få returnert _alle_ verdier med minste verdi, må vi bruke `which(x == min(x))`. I dette eksempelet gir begge varianter det samme resultatet; vi finner minste verdi i observasjon `r which.min(nokeur_df$Verdi)`.
which.min(nokeur_df$Verdi) # or
which(nokeur_df$Verdi == min(nokeur_df$Verdi))

#' 6. For denne oppgaven skal vi lage to nye vektorer; `kurs_1` og `kurs_2`. Den første inneholder første til _nest siste_ kurs i datasettet, og den andre inneholder _andre_ til siste kurs i datasettet. Dette er en av mange fordeler med å bruke et språk som R fremfor andre statistikkpakker; vi kan opprette nye objekter for å gjennomføre tester og analyser. I dette tilfellet ønsker vi å sjekke om prisen av en euro i kroner har gått _opp_ eller _ned_ fra en måned til neste. For å løse dette, bruker vi vanlig syntak i R for å subsette en vektor (husk at én kolonne i en `data.frame` returnerer en vektor). Vi finner nest siste verdi med `nrow(nokeur_df)-1`. Siste del av oppgaven er å opprette objektet `kurs_endring` som har verdiene `"Opp"` hvis verdien i `kurs_2` er _større_ enn `kurs_1`, og `"Ned"` hvis ikke (den observante leser vil her se at tilfeller hvor kursen er _lik_ i begge perioder vil bli kodet `"Ned"`, men siden dette er en variabel på intervallnivå, tar vi likevel sjansen). Siden både `kurs_1` og `kurs_2` er vektorer, bruker vi `ifelse` som er vektorisert. `ifelse` tar tre argumenter, uttrykket vi skal sjekke (som må evaluere til en boolsk verdi), hva som skal returneres hvis uttrykket evalueres til `TRUE` og hva som skal returneres hvis uttrykket evalueres til `FALSE`.

kurs_1 <- nokeur_df$Verdi[1:nrow(nokeur_df)-1] # length(nokeur_df$Verdi) will also work
kurs_2 <- nokeur_df$Verdi[2:nrow(nokeur_df)]
kurs_endring <- ifelse(kurs_2 > kurs_1, "Opp", "Ned")

#' 7. For å finne hvor mange ganger kursen har gått _opp_ kan vi bruke et boolsk uttrykk. Dette returnerer en vektor med `TRUE` og `FALSE`-verdier. Husk at `TRUE` representeres numerisk med verdien `1` og `FALSE` representeres ved `0`. Vi kan dermed bruke funksjonen `sum` for å telle hvor mange ganger `kurs_endring` er lik `"Opp"`.

sum(kurs_endring == "Opp")

#' 8. Vi gjør det samme for å telle hvor mange ganger `kurs_endring` er lik `"Ned"`. Merk at vi i dette tilfellet også kunne sjekket om `kurs_endring` _ikke er lik_ `"Opp"`.

sum(kurs_endring == "Ned")

#' 9. I den siste oppgaven skal vi bruke `plot` for å lage et linjediagram med kurs over tid. Hvis vi se på hjelpesiden til `plot` med `?plot`, ser vi at funksjonen tar et argument `type` for linjediagram. For at plottet skal bli finere, bruker vi her også `ylab` for å angi etiketten på y-aksen, og `xlab` for å angi etiketter på x-aksen.

#+ error=TRUE, fig.keep='none'
plot(nokeur_df$Tid, nokeur_df$Verdi, type = 'l', ylab = 'Kurs', xlab = 'Tid')

#' Hvis vi kjører denne funksjonen direkte, får vi kun feilmeldinger (i tidligere versjoner av R enn versjon 4, ville vi fått et diagram, men med et ganske uventet resultat). Dette skjer fordi kolonnen `Tid` ikke er en numerisk variabel, og R får en feilmelding når R forsøker å konvertere denne kolonnen til numeriske verdier. Dette kan vi sjekke med `class`:

class(nokeur_df$Tid)

#' Ved å lage en ny vektor med datoobjekter, kan vi få en variabel som plotter et linjediagram. Vi kan opprette et datoobjekt med funksjonen `as.Date`. Verdiene i `Tid`-kolonnen har formatet `YYYY-MM`, men `as.Date` forventer en tekststreng i formatet `YYYY-MM-DD`. Vi må derfor legge til en dag. Det mest rasjonelle i dette tilfellet, er å legge til den første dagen i måneden (siden siste dag varierer etter måned). Vi kan bruke `paste` for å slå sammen to tekststrenger, og bruke argumentet `sep` for å angi at de skal slås sammen med `-`.
#' 
#' Vi oppretter et nytt objekt `ts` som har verdier i riktig datoformat. Merk at siden `Tid` er av typen faktor, må vi konvertere denne til `character` med funksjonen `as.character`:

ts <- as.Date(paste(as.character(nokeur_df$Tid), '01', sep = '-'))

#' Når vi prøver `plot` på nytt, får vi et linjediagram som forventet:

plot(ts, nokeur_df$Verdi, type = 'l', ylab = 'Kurs', xlab = 'Tid')

#' Det finnes flere pakker i R som gjør det lettere å jobbe med dato og tidvariabler. To av de bedre pakkene er `zoo` og `lubridate`. Vi kan installere disse med `install.packages` og gjøre dem tilgjengelig i den aktive R-sesjonen med `library`. Pakken `zoo` inneholder en funksjon `as.yearmon` som kan konvertere variabler i formatet `YYYY-MM` til et datoobjekt. Vi bruker denne funksjonen til å opprette objektet `ts2` og plotter linjediagrammet på nytt.

library(zoo)
ts2 <- zoo::as.yearmon(nokeur_df$Tid)
plot(ts2, nokeur_df$Verdi, type = 'l', ylab = 'Kurs', xlab = 'Tid')
