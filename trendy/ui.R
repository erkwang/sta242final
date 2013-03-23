#shiny web-app
#ui.R
library(shiny)
library(twitteR)

#available trend locations
availloc = availableTrendLocations()

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Location Twitter Trends"),
  
  sidebarPanel(
    selectInput("country", "Country:", choices = as.list(unique(availloc$country[-1]))),
    
    uiOutput("CitySelect"),
    
    uiOutput("TrendSelect")
  ),
  
  mainPanel(
    h4("Related Tweets"),
    verbatimTextOutput("text"),
    htmlOutput("source")
  )
))









