#STA 242 Final Project
#text mining
#twitter insights
#visualization possibility

#load all packages
load("~/Desktop/TwitterCred.rda")
library(ROAuth)
library(twitteR)
library(googleVis)

#tackle OAuth
registerTwitterOAuth(.TwitterCred)


#grab Twitter Trends of a given location


locTrend = function(location){
  #get all available locations for searching trends
  avail.loc = availableTrendLocations()
  if (location %in% avail.loc$name) loc.found = TRUE else loc.found = FALSE
  if (loc.found)
  {
  loc.id = avail.loc$woeid[avail.loc$name == location]
  trend = getTrends(loc.id)
  trend$location = location
  ## Create table with googleVis
  trendtb = gvisTable(trend[,c("location", "name")],
                   options=list(height=250),
                   chartid="Trends")
  link = paste("<a href=", trend$url, ">", trend$name, "</a><br>", sep = "", collapse = "\n")
  link = paste('<font size = "4">', link, '</font>', sep = "\n")
  chart = paste(trendtb$html$chart, collapse="\n")
  topics = paste('<div id="contentBox" style="margin:0px auto; width:100%">',
                 '<div id="column1" style="float:left; margin:0; width:50%;">',
                 chart, '<font size="6">Find them on Twitter:</font><br>',
                 link, "</div>", sep = "\n")
  tweets = getTweets(trend$name)
  page = paste(trendtb$html$header, topics, tweets,trendtb$html$footer, sep = "\n")
  cat(page, file = "~/Downloads/Trends.html")
  }
  else{
    stop("location not available for trends")
  }
}

getTweets = function(keywords)
{
  tweets = lapply(keywords, function(x)searchTwitter(x, n = 1, lang = "en"))
  
}



