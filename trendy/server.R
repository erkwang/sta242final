#shiny web-app
#server.R
library(shiny)
library(twitteR)
library(ROAuth)
library(googleVis)

#register OAuth
load("./TwitterCred.rda")
registerTwitterOAuth(.TwitterCred)


#available trend locations
availloc = availableTrendLocations()

shinyServer(function(input, output){
  
  #get the corresponding name of cities in one country
  #create a select menu with place names within a country
  output$CitySelect <- renderUI({
    city <- availloc$name[availloc$country == input$country]
    selectInput("place", "Choose Place", as.list(city))
  })
  
  #create a select menu with trends
  trend <- reactive({
    locid <- availloc$woeid[availloc$name == input$place]
    trends <- getTrends(locid)
  })
  
  output$TrendSelect <- renderUI({ 
    t = trend()
    selectInput("trend", "Trends", as.list(t$name))
  })
  
  #grab tweets for selected topics
  tweet <- reactive({
    tweets <- searchTwitter(searchString = input$trend, n = 10)
    tweets <- lapply(tweets, as.data.frame)
    tweets <- do.call("rbind", tweets)
    tweets
  })
  
  #create display of tweets
  output$text <- renderPrint({
    text <- paste(tweet()$text, collpase="\n\n")
    cat(text)
  })
  
  #create counts for tweets sources
  output$source <- renderGvis({
    sources <- gsub("</a>", "", tweet()$statusSource)
    sources <- strsplit(sources, ">")
    sources <- sapply(sources, function(x) ifelse(length(x) > 1, x[2], x[1]))
    sources <- table(sources)
    sources <- data.frame(source = names(sources), count = sources)
    gvisPieChart(sources, labelvar="source", numvar="count")
  })
  
})


