library(shiny)

source("brewmap.R")

# thanks for watching

ui <- fluidPage(
  titlePanel("Brewery by Naming Convention Map"),

  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("category", "Location Info:",
                         choices = c("None", "Multiple", "Zip", "City", "Area", "State", "Address"),
                         selected = c("None", "Multiple", "Zip", "City", "Area", "State", "Address")),
      selectInput("state", "State:", choices = c("All", unique(brew_df$state_province)), selected = "All")
    ),
    mainPanel(plotOutput("map", height = "600px")
    )
  )
)

server <- function(input, output) {
  output$map <- renderPlot({
    filtered <- brew_df %>%
      filter(category %in% input$category) %>%
      filter(state_province == input$state | input$state == "All")

    ggplot() +
      geom_polygon(
        data = us_map,
        aes(x = long, y = lat, group = group),
        fill = "lightgray",
        color = "white"
      ) +
      coord_fixed(1.3) +
      theme_minimal() +
      geom_point(data = filtered, aes(x = longitude, y = latitude, color = category))
  })
}

shinyApp(ui = ui, server = server)
