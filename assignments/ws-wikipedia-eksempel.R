#### ---- HENT WIKIPEDIA-SIDEN TIL UTVALGTE STORTINGSREPRESENTANTER ---- ####

# Dette skriptet henter Wikipedia-sidene til noen utvalgte norske 
# stortingsrepresentanter, og sjekker hvilke komiteer disse sitter i. 


# Oppstart ----------------------------------------------------------------

# Fjern alt i workspace 
rm(list = ls())

# Last inn pakker 
library(httr);library(rvest)


# Skrap Wikipedia-siden om norske stortingsrepresentanter -----------------

# Definer en variabel med URLen som skal skrapes 
the_url <- 'https://no.wikipedia.org/wiki/Liste_over_stortingsrepresentanter_2017%E2%80%932021'

# Send en GET-forespørsel til URLen 
resp <- GET(the_url)
resp

# Hent ut HTML-teskten fra repsonsen 
the_html <- content(resp)
the_html

# Finn alle tabeller i HTML-teksten 
the_tables <- html_nodes(the_html, "table")
the_tables # Representanttabellen ligger i tabell 2 

# Hent ut tabellen med representanter 
MPs <- html_table(the_tables[[2]], fill = TRUE)

# Fjern overflødige objekter fra workspace 
rm(resp, the_html, the_url)


# Skrap Wikipedia-sidene til et knippe utvalgte representanter ------------

# Lag en vektor med URL-ene til noen utvalgte representanter 

my_reps <- c('Sylvi Listhaug', 'Kjell Ingolf Ropstad', 'Ine Eriksen Søreide',
             'Audun Lysbakken', 'Sandra Borch')
the_links <- the_tables[2] %>% html_nodes('a') %>% html_attr('href')
the_texts <- the_tables[2] %>% html_nodes('a') %>% html_text()
the_urls <- the_links[the_texts %in% my_reps]
the_urls <- sprintf('https://no.wikipedia.org%s', the_urls)

# Fjern overflødige objekter fra workspace 
rm(the_links, the_tables, the_texts)

# Hent inn Wikipedia-sidene til de utvalgte representantene 
the_htmls <- lapply(the_urls, function(u){
  Sys.sleep(.5)
  r <- content(GET(u))
  return(r)
})

# Lag en tabell med navn, komité og år 
the_list <- lapply(the_htmls, function(h){
  
  n <- h %>% 
    html_node('h1') %>% 
    html_text()

  t <- h %>%
    html_nodes('ul > li > a') %>% 
    html_attr('title')
  
  y <- h %>%
    html_nodes('ul > li') %>%
    html_text()
  y <- y[grepl('komité', t)]
  
  c <- t[grepl('komité', t)] 
  y <- gsub(':.*', '', y)
  n <- rep(n, length(y))
  
  data.frame(name = n, commitee = c,
             year = y,
             stringsAsFactors = FALSE)
  
})
df <-  do.call('rbind', the_list)
# rm(the_list, the_htmls)

# Merk at én representant mangler  
# Kan du finne ut hvorfor?  
unique(df$name)
length(the_list)
the_htmls[[5]]
the_list[[5]]


