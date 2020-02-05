#### ---- HENT INFORMASJON OM NORSKE REGJERINGER FRA NSD ---- ####

# Dette skriptet henter  informasjon om norske regjeringer siden 1884 
# fra NSDs database PolSys. 



# Oppstart ----------------------------------------------------------------

# Fjern alt i workspace
rm(list = ls())

# Last inn pakker
library(httr);library(rvest)

# Les inn HTML-siden 
the_url <- 'https://nsd.no/polsys/index.cfm?urlname=regjering&lan=&UttakNr=39&MenuItem=N1_2&ChildItem=&State=collapse'
the_html <- read_html(the_url)
rm(the_url)


# Hent ut hovedtabell og dens URLer ---------------------------------------

# Hent ut tabellen over regjeringer og deres ansiennitet 
df <- the_html %>% 
  html_nodes('table') %>%  # Finn alle HTML-tabeller på siden 
  .[[1]] %>%               # Velg ut den første tabellen 
  html_table()             # Konverter til en data frame 

# Hent ut URLene i tabellen 
the_urls <- the_html %>% 
  html_nodes('table') %>%  # Finn alle HTML-tabeller på siden 
  .[[1]] %>%               # Velg ut den første tabellen 
  html_nodes('a') %>%      # Velg ut alle 'a' elementer 
  html_attr('href')        # Velg ut 'href' attributte


# Skrap innholdet på alle koblingene i tabellen  --------------------------

# Sjekk ut hvordan URLene ser ut
head(the_urls) # Mangler basisurl / nettsted 

# Slå sammen URLene med basisurlen 
the_urls <- paste0('https://nsd.no/polsys/', the_urls)
  
# Hent nettsiden for hver av de nye URLene 
the_list <- lapply(the_urls, function(u){
  Sys.sleep(1)
  message(u)
  r <- content(GET((u)))
  r
})


