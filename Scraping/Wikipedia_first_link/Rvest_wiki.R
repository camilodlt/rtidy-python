# LIBRARIES ------
library(rvest) # scraping tool
library(purrr) # list utils

# SETTINGS ------ 
words<-c('dog','economics','hair')
url='https://en.wikipedia.org' # Base URL
found_links= list()
# FUNCTIONS ------
find_links_function <- function(url){

  site<- read_html(url)
  # * Extract the content div
  link<-site%>%
    html_elements('.mw-parser-output')%>% 
    html_elements('p')
  # * Identify where there are bold elements
  bold <-link %>% html_element('b') # notice html_element, returns same length object
  # * See which elements are NA
  # NA elements denote elements that do not have bold <b></b> 
  # Select the first that matches as the word of the article always appears bold in the first paragraph.
  first_text<-which(!is.na(bold))[1]
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
  # Init 
  link<- list()
  link[['title']]<- word
  complete_url= paste0(url,'/wiki/',word = link[['title']])
  exit_found<- 0
  while(exit_found==0){
  # * Find the first useful link
  link<-find_links_function(url = complete_url) # find the first link that it's not spelling help or citation
  # Append the link and the title to a list
  title<-link[['title']]
  found_links[[word]][[title]]<- link[["href"]]
  # Get the next url
  complete_url<- paste0(url,link[["href"]])
  # If Philosophy break
  if(title=="Philosophy"){exit_found<-1}
  }
  Sys.sleep(3)
}

clean_links<- function(provide_links){
  
  # * Remove citations and spelling links  
  for(i in 1:length(provide_links)){
    if(stringr::str_detect(pattern='Help:IPA',provide_links[[i]][['href']])){
      provide_links[[i]]<-NA
    } else 
      if (stringr::str_detect(pattern='cite_note',provide_links[[i]][['href']])){
        provide_links[[i]]<-NA
      }
  }
  return(provide_links)
}
