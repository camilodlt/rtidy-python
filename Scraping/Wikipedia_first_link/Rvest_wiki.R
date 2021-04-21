# LIBRARIES ------
library(rvest) # scraping tool
library(purrr) # list utils

# SETTINGS ------ 
words<-c('science','dog','cuisine','economics', 'love')
url='https://en.wikipedia.org' # Base URL
found_links= list()

# FUNCTIONS ------
# * Skips exeptions
skip= c('/wiki/English_in_the_Commonwealth_of_Nations',
        '/wiki/American_English', # links that focus on spelling differences
        '/wiki/Ancient_Greek_language',
        '/wiki/Romanization_of_Ancient_Greek',
        '/wiki/Literal_translation',
        '/wiki/Latin',
        '/wiki/Greek_language',
        '/wiki/-logy',
        '/wiki/Hebrew_language')
# * Clean links to remove citations and spelling helpers in wikipedia
clean_links<- function(provide_links){
  
  # * Remove citations and spelling links  
  for(i in 1:length(provide_links)){
    if(stringr::str_detect(pattern='Help:IPA',provide_links[[i]][['href']])){
      provide_links[[i]]<-NA
    } else 
      if (stringr::str_detect(pattern='cite_note|.ogg|wiktionary',provide_links[[i]][['href']])){
        provide_links[[i]]<-NA
      }
    else if(stringr::str_detect(pattern='spelling.+difference',provide_links[[i]][['href']])){
      provide_links[[i]]<-NA
    } 
    else if (stringr::str_detect(pattern='ISO',provide_links[[i]][['href']])){
      provide_links[[i]]<-NA
    }
    else if (stringr::str_detect(pattern='/wiki/.+language',provide_links[[i]][['href']])){
      provide_links[[i]]<-NA
    }
    else if (provide_links[[i]][['href']]%in% skip){
      provide_links[[i]]<-NA
    }
  }
  return(provide_links)
}
# * Find links of a wikipedia website
find_links_function <- function(url,title){

  site<- read_html(url)
  closeAllConnections()
  # * Extract the content div
  link<-site%>%
    html_elements('.mw-parser-output')%>% 
    html_elements('p')
  # * Identify where there are bold elements
  bold <-link %>% html_element('b') # notice html_element, returns same length object
  # Rectangle with information. We don't want that
  notsave<-site%>%html_elements('.nomobile')%>% html_elements('b')
  # Get indexes 
  notsave<-which(bold%in%notsave)
  # * Look for the word in the text 
  lookout<-stringr::str_replace_all(title,'\\s',"|")
  # * accept partial matching 
  bold<- bold%>% html_text2()%>% purrr::map(~stringr::str_replace_all(.x,'\\s','|')) # Words
  
  bold<-bold%>% purrr::map(~adist(.x,lookout, ignore.case = T, fixed = FALSE
                                                                )) # Accommodate the search for names,ex: charles darwin as charles robert darwin. Searches for Biology with bological... Fixed = FALSE enables regex
  # Unlist bold 
  bold<- unlist(bold)
  # Give rectangle values an infinite distance 
  bold[notsave]<-Inf
  # Subset before 15 nodes 
  bold<-bold[1:15] # TODO, maybe diff for when not save exists (high number, if not low number).
  # Select the closest distance to the word of the article.
  first_text<-which(bold==min(bold, na.rm = T))[1]
  # * Extract links and attributes
  links_in_text<- link[first_text]%>% html_elements('a')%>% html_attrs()
  # Clean links 
  links_in_text<- clean_links(links_in_text)
  # Remove NA
  pure_links<-discard(links_in_text,~all(is.na(.)))
  if(is_empty(pure_links)){ # If there is no useful link in the first paragraph look at the second.
    # Although I think is rare 
    first_text<- first_text+1
    # * Extract links and attributes
    links_in_text<- link[first_text]%>% html_elements('a')%>% html_attrs()
    # Clean links 
    links_in_text<- clean_links(links_in_text)
    # Remove NA
    pure_links<-discard(links_in_text,~all(is.na(.)))
    }
  Sys.sleep(3)
  return(pure_links[[1]]) # Pick first link that is not a citation or spelling link
}
# SCRAPING ------
for(word in words){
  # Print
  print(paste('------',word,'------'))
  # Init 
  link<- list()
  link[['title']]<- word
  complete_url= paste0(url,'/wiki/',word = link[['title']])
  exit_found<- 0
  while(exit_found==0){
  # * Find the first useful link
  link<-find_links_function(url = complete_url,title=link[['title']]) # find the first link that it's not spelling help or citation
  # Append the link and the title to a list
  title<-link[['title']]
  found_links[[word]][[title]]<- link[["href"]]
  # Get the next url
  complete_url<- paste0(url,link[["href"]])
  cat(".")
  message(title)
  # If Philosophy break
  if(title=="Philosophy"){exit_found<-1}
  }
  Sys.sleep(3)
}

