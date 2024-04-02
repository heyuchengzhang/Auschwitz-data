#### Preamble ####
# Purpose: This is a Shiny web application about the ethnic origins and number of Holocaust victims killed at Auschwitz concentration camp.
# Author: Heyucheng Zhang
# Date: 31 March 2024 
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: Get "analaysis_data" from "https://encyclopedia.ushmm.org/content/en/article/auschwitz"

#### Workspace setup ####
library(shiny)
library(ggplot2)

#### Shiny web application ####
# "analaysis_data" contains the nationality and number of victims, obtained from "https://encyclopedia.ushmm.org/content/en/article/auschwitz".
analaysis_data <- data.frame(
  Nationality = c("Hungarian", "Polish", "French", "Dutch", "Greek", "Bohemian and Moravian", "Slovakian", "Belgian", "Yugoslavian", "Italian", "Norwegian", "Other"),
  Number_of_Victims = c(426000, 300000, 69000, 60000, 55000, 46000, 27000, 25000, 10000, 7500, 690, 34000)
)

# Define UI
ui <- fluidPage(
  # Application title
  titlePanel("The Number of Holocaust Victims at Auschwitz by Nationality"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selected_nationality", "Select Nationality:", 
                         choices = analaysis_data$Nationality)
    ),
    
    # Show a plot and a table
    mainPanel(
      plotOutput("victimsPlot"),
      tableOutput("victimsTable")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # nationality_data based on selected nationality
  nationality_data <- reactive({
    analaysis_data[analaysis_data$Nationality %in% input$selected_nationality,]
  })
  
  output$victimsPlot <- renderPlot({
    # Make Plot
    ggplot(nationality_data(), aes(x = Nationality, y = Number_of_Victims, fill = Nationality)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(x = "Nationality", y = "Number of Victims", fill = "Nationality")
  })
  
  output$victimsTable <- renderTable({
    # Make Table
    nationality_data()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
