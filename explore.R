library(httr)
library(jsonlite)
library(tidyverse)
library(skimr)

brew_1 <- fromJSON("https://api.openbrewerydb.org/v1/breweries?by_country=united_states&per_page=200&sort=type,name:asc&by_type=micro&page=1")
brew_2 <-
brew_desc <- fromJSON("https://api.openbrewerydb.org/v1/breweries?by_country=united_states&per_page=200&sort=type,name:desc&by_type=micro")

