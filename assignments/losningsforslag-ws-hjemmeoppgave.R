################### ------- HJEMMEOPPGAVE ------ ########################
#                                                                       #
# ----------------- ANTALL SIDEVISNINGER PÅ WIKIPEDIA ----------------- #              
#                                                                       #
# I denne oppgaven skal du finne frem til hvilken stortingsrepresentant #
# som har hatt flest sidevisninger på Wikipedia i løpet av den          #
# inneværende stortingsperioden (altså siden 2. oktober 2017).          #
#                                                                       #
# Først må du hente inn oversiktsiden over stortingsrepresentantene.    #
#                                                                       #
# Deretter må du finne frem til navnene på representantene som finnes i #
# tabellen.                                                             #
#                                                                       #
# Du kan bruke pakken 'pageviews' til å hente inn antall sidevisninger  #
# en Wikipedia-side har hatt siden en gitt dato.                        #  
# Hint: sjekk ut funksjonen 'article_pageviews'.                        #
#                                                                       #
# Lag en liste medresultatet fra denne funksjonen for hver representant # 
# Hint: sjekk ut 'lapply'.                                              #  
#                                                                       #               
# Bind sammen listen til en 'data.frame' og finn frem til hvilken       # 
# representant som har fleste sidevisninger.                            #
#                                                                       #
# --------------------------------------------------------------------- #

# Fjern alt i workspace
rm(list = ls())

# Last inn pakker 
library(httr); library(rvest); 

# Last inn oversiktssiden over norske stortingsrepresentanter på nytt 
# Hint: Sjekk ut funksjonen read_html i rvest-pakken eller funksjonene
# GET og content i httr-pakken. URL-en du skal bruke er:
# https://no.wikipedia.org/wiki/Liste_over_stortingsrepresentanter_2017%E2%80%932021

my_html <- content(GET('https://no.wikipedia.org/wiki/Liste_over_stortingsrepresentanter_2017%E2%80%932021'))

# Hent ut tekst og lenker fra representanttabellen 
# Hint: Sjekk ut funksjonene html_nodes, html_attr og html_text i 
# rvest-pakken 

the_links <- my_html %>% 
  html_nodes('[class="wikitable sortable"]') %>% 
  html_nodes('a') %>% 
  html_attr('href')

the_texts <- my_html %>% 
  html_nodes('[class="wikitable sortable"]') %>% 
  html_nodes('a') %>% 
  html_text()

# Filtrer bort fylker
fylker <- c('Østfold','Akershus', 'Oslo', 'Hedmark', 'Buskerud',
            'Telemark','Vestfold', 'Vest-Agder', 'Aust-Agder', 
            'Oppland', 'Hordaland', 'Rogaland', 'Sogn og Fjordane',
            'Sør-Trøndelag', 'Nord-Trøndelag', 'Møre og Romsdal', 
            'Nordland', 'Troms', 'Finnmark')
the_MPs <- the_texts[!the_texts %in% fylker]

# Filtrer bort partier 
# Hint: Hvor mange tegn er det i de ulike tekststrengene? 
the_MPs <- the_MPs[nchar(the_MPs) > 3]

# Er det mer som bør filtreres bort ? 
# Hint: Print ut the_MPs objektet til konsollen. 
# Er det bare lenker til personer som gjenstår? 
the_MPs <- the_MPs[!grepl("Stortingspresident", the_MPs)]

# Last inn pakken og sjekke ut funksjonen 
# Tips: Du må installere pakken dersom du ikke
# har den fra før. 
library(pageviews)
?article_pageviews

# Gjenta funksjonen 'article_pageviews' over en vektor med 
# navnet på alle representantene  Lagre listen i et objekt 
# med navn 'dl_pageviews'. 
# 
# Merk: Du vil kunne få feilmeldinger for enkelte lenker. 
# Det anbefales derfor å legge funksjonen article_pageviews
# inn i en try-funksjon. 

# NB! Oppgaven spør i utgangspunktet etter sidevisninger i 
# inneværende stortingsperiode, ikke kun visninger for en enkelt 
# dag. Det er derfor nødvendig å sette både en start og slutt dato. 

dl_pageviews <- 
  lapply(the_MPs, function(x) try(
    article_pageviews(
      project = 'no.wikipedia',
      article = x,
      start = '20171002000000', # 2. oktober 2017 kl. 00:00:00
      end =   '20200204150000'  # 4. februar 2020 kl. 15:00:00
  )
  ))

# Her bruker vi en egen funksjon, is_error, til få finne ut 
# hvilke forespørsler som ikke ga en 'try-error. 
# Du må fullføre koden for å filtrere ut disse. 
is_error <- function(x) inherits(x, 'try-error')
succeeded <- !vapply(dl_pageviews, is_error, logical(1))
dl_pageviews_succeeded <- dl_pageviews[succeeded]

# Bind sammen til en data frame
df <- do.call('rbind', dl_pageviews_succeeded)

# Spørsmål 1: Hvilken representant har flest sidevisninger?

# Aggreger visninger per representant 
df_agg <- aggregate(df$views, by = list(df$article), sum) 

df_agg[which.max(df_agg$x),] # Svar: Erna Solberg

# Spørsmål 2: Hvor mange representanter har kun én sidevisning? 
nrow(df_agg[df_agg$x == 1,]) # Svar: 0 
