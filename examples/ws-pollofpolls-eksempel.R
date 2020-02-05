#### ---- HENT NASJONALE MENINGSMÅLINGER FRA POLLOFPOLLS.NO ---- ####

# Dette skriptet henter alle nasjonale meningsmålinger som er 
# gjennomført siden stortingsvalget 2017 fra nettstedet 
# pollofpolls.no.  


# Oppstart ----------------------------------------------------------------

rm(list = ls())
library(httr);library(rvest)

# Hent hovedsiden  --------------------------------------------------------

# Les inn HTML-siden 
the_html <- content(GET('http://www.pollofpolls.no/?cmd=Stortinget&do=visallesnitt'))

# Hent ut URL-ene i hovedtabellen (tabell 1)
the_urls <- the_html %>% 
  html_nodes('table') %>% 
  .[1] %>% 
  html_nodes('a') %>% 
  html_attr('href') 
rm(the_html)

# Fjern lenker som peker til partier 
the_urls <- the_urls[!grepl('Partier', the_urls)]

# Legg til basisurl til nettstedet
the_urls <- paste0('http://www.pollofpolls.no/', the_urls)

# Velg ut månedene siden forrige Stortingsvalg (altså fra oktober 2017)
the_urls <- the_urls[1:grep('201710',the_urls)]


# Hent gjennomsnittsidene for hver måned  ---------------------------------

# Hent HTML-sidene 
the_htmls <- lapply(the_urls, function(u){
  Sys.sleep(.5)
  r <- content(GET(u))
  return(r)
})
rm(the_urls)

# Finn URL-ene til hver enkelt meningsmåling 
the_urls <- lapply(the_htmls, function(h){
  h %>% 
    html_nodes('table') %>% 
    .[1] %>% 
    html_nodes('a') %>% 
    html_attr('href')
})

# Gjør om til én felles liste 
the_urls <- unlist(the_urls)

# Legg til basisurl til nettstedet
the_urls <- sprintf('http://www.pollofpolls.no/%s', the_urls)


# Lag tabell med alle meningsmålinger  ------------------------------------

# Hent ut den første tabellen fra hver HTML-side 
the_list <- lapply(the_htmls, function(h){
  h %>% 
    html_table() %>% 
    .[[1]]
})

# Bind sammen til en data.frame  
df <- do.call('rbind', the_list)

# Gi den første kolonnen et navn 
names(df)[1] <- 'Måling'

# Fjern rader som inneholder gjennomsnitt eller feilmargin 
df <- df[!grepl('Gjennomsnitt|Feilmargin', df$Måling),]

# Legg til en id variabel 
df$id <- gsub('.*=', '', the_urls)
rm(the_list)

# Hent siden til hver enkelt meningsmåling --------------------------------
the_htmls <- lapply(the_urls, function(u){
  Sys.sleep(.5)
  r <- content(GET(u))
  return(r)
}) 

# Finn den første tabellen på hver side og gjør om til en rad 
the_list <- lapply(the_htmls, function(h){
  t <- h %>% 
    html_table() %>%
    .[[1]]
  out <- rbind(t$X2)
  colnames(out) <- rbind(t$X1)
  out <- as.data.frame(out)
  return(out)
})

# Bind sammen listen 
df2 <- data.table::rbindlist(the_list, fill = TRUE)

# Fjern mellomrom i kolonnenavn 
names(df2) <- gsub(' ', '_', names(df2))

# Rydd i workspace
rm(the_htmls, the_list, the_urls)

# Lag endelig tabell ------------------------------------------------------

# Bind sammen df og df2. 
df <- cbind(df2, df)
rm(df2)
