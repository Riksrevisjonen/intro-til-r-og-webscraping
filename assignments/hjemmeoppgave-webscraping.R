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
...

# Last inn oversiktssiden over norske stortingsrepresentanter på nytt 
# Hint: Sjekk ut funksjonen read_html i rvest-pakken eller funksjonene
# GET og content i httr-pakken. URL-en du skal bruke er:
# https://no.wikipedia.org/wiki/Liste_over_stortingsrepresentanter_2017%E2%80%932021
my_html <- ...

# Hent ut tekst og lenker fra representanttabellen 
# Hint: Sjekk ut funksjonene html_nodes, html_attr og html_text i 
# rvest-pakken 
the_links <- ...
the_texts <- ...

# Filtrer bort fylker
fylker <- c('Østfold','Akershus', 'Oslo', 'Hedmark', 'Buskerud',
            'Telemark','Vestfold', 'Vest-Agder', 'Aust-Agder', 
            'Oppland', 'Hordaland', 'Rogaland', 'Sogn og Fjordane',
            'Sør-Trøndelag', 'Nord-Trøndelag', 'Møre og Romsdal', 
            'Nordland', 'Troms', 'Finnmark')
the_MPs <- the_texts[... %in% ...]

# Filtrer bort partier 
# Hint: Hvor mange tegn er det i de ulike tekststrengene? 
the_MPs <- the_MPs[...(the_MPs) > 3]

# Er det mer som bør filtreres bort ? 
# Hint: Print ut the_MPs objektet til konsollen. 
# Er det bare lenker til personer som gjenstår? 
...


# Last inn pakken og sjekke ut funksjonen 
# Tips: Du må installere pakken dersom du ikke
# har den fra før. 
library(...)
?... 


# Gjenta funksjonen 'article_pageviews' over en vektor med 
# navnet på alle representantene  Lagre listen i et objekt 
# med navn 'dl_pageviews'. 
# 
# Merk: Du vil kunne få feilmeldinger for enkelte lenker. 
# Det anbefales derfor å legge funksjonen article_pageviews
# inn i en try-funksjon. 
dl_pageviews <- 
  ...(..., function(x) try(
    ...
  )
))


# Her bruker vi en egen funksjon, is_error, til få finne ut 
# hvilke forespørsler som ikke ga en 'try-error. 
# Du må fullføre koden for å filtrere ut disse. 
is_error <- function(x) inherits(x, 'try-error')
succeeded <- !vapply(x, is_error, logical(1))
dl_pageviews_succeeded <- dl_pageviews[...]


# Bind sammen til en data frame
df <- ...


# Spørsmål 1: Hvilken representant har flest sidevisninger?
...


# Spørsmål 2: Hvor mange representanter har kun én sidevisning? 
...