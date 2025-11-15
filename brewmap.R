library(ggplot2)
library(maps)
library(stringdist)

source("explore.R")

brew_df <- brew_df %>%
  filter(!is.na(latitude)) %>%
  filter(latitude < 50 & latitude > 20 & longitude > -130)

brew_df <- brew_df %>%
 mutate(area_code = substr(phone, 1, 3))

brew_df <- brew_df %>%
  mutate(name_contains_zip = str_detect(name, postal_code)) %>%
  mutate(name_contains_city = str_detect(name, city)) %>%
  mutate(name_contains_area = str_detect(name, area_code)) %>%
  mutate(name_contains_state = str_detect(name, state_province))

brew_df <- brew_df %>%
  rowwise() %>%
  mutate(address_parts = list(str_split(street, "\\s+")[[1]]),
         address_parts = list(address_parts[nchar(address_parts) > 3]),
         address_contains = any(str_detect(name, address_parts))) %>%
  ungroup()

brew_df <- brew_df %>%
  mutate(category = case_when(name_contains_city + name_contains_area + name_contains_state + address_contains > 1 ~ "Multiple",
    name_contains_city ~ "City",
    name_contains_area ~ "Area",
    name_contains_state ~ "State",
    address_contains ~ "Address",
    TRUE ~ "None"))

us_map <- map_data("state")

ggplot() +
  geom_polygon(
    data = us_map,
    aes(x = long, y = lat, group = group),
    fill = "lightgray",
    color = "white"
  ) +
  coord_fixed(1.3) +
  theme_minimal() +
  geom_point(data = brew_df, aes(x = longitude, y = latitude, color = category))


