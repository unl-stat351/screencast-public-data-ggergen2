library(httr)
library(jsonlite)
library(tidyverse)
library(skimr)
library(fuzzyjoin)

url_base <- "https://api.openbrewerydb.org/v1/breweries?by_country=united_states&per_page=200&sort=type,name:asc&by_type=micro"

all_breweries <- list()
page <- 1

repeat {
  url <- paste0(url_base, "&page=", page)

  data <- fromJSON(url)

  if (length(data) == 0) {
    break
  }

  all_breweries[[page]] <- data

  page <- page + 1
}

brew_df <- bind_rows(all_breweries)

# # Area codes
# area_codes <- read.csv("us-area-code-cities.csv")
#
# colnames(area_codes) <- c("201", "Bayonne", "New Jersey", "US", "40.66871", "-74.11431")
#
# area_codes <- rbind(colnames(area_codes), area_codes)
#
# colnames(area_codes) <- c("area_code", "city", "state_province", "country", "latitude", "longitude")
#
# # Area code from brew phone
#
# state_area_code <- brew_df %>%
#   select(state, area_code) %>%
#   distinct()
#
# # join area_codes and brew_df
# brew_df <- brew_df %>%
#   left_join(area_codes, by = c("city", "state_province")) %>%
#   mutate(area_code.x = if_else(is.na(area_code.x), area_code.y, area_code.x))




