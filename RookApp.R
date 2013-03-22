#Build an web application


library(Rook)
s = Rhttpd$new()
s$start(quiet = TRUE)

#app for reading twitter trends
trend.app = function(env){
  req = Request$new(env)
  res = Response$new()
  
  avail.loc = availableTrendLocations()
  country = unique(avail.loc$country)
  country = paste("<option value='", country, "'>", country, '</option>', sep = "")
  res$write("<form enctype='multipart/form-data' method=POST>")
  res$write("<select onchange='this.form.submit()'>")
  for (i in 1:length(country)) res$write(country[i])
  res$write("</select>")
  res$write("</form><br><pre>")
  res$write(paste("<font size='6'>", capture.output(str(Multipart$parse(env)), file = NULL), 
                  "</font>", sep = "", collapse = "\n"))
  
  res$finish()
  
  #req2 = Request$new(env)
  #res2 = Response$new
  
  #local = avail.loc$name[avail.loc$country == countrysel]
  #local = paste("<option value='", local, "'>", local, '</option>', sep = "")
  #res$write("<select>")
  #for (i in 1:length(local)) res$write(local[i])
  #res$write("</select>")
}

s$add(name = "trend", app = trend.app)
s$browse("trend")
s$remove(all=TRUE)








