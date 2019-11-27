#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
#install.packages("plotly")
require(devtools)
library(plotly)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")
# Change based on what your application is

# Change based on what you 
myapp <- oauth_app(appname = "Access_Github",
                   key = "35cadfc1cc0414d6f04d",
                   secret = "3b86c1d2896b7c733f1d9706d1aeed91851664e3")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/patrickByrne99/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "patrickByrne99/Github_API", "created_at"]

#above code sourced from https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

#Interrogate the Github API to extract data from my own github account

#gets my data 
myData = fromJSON("https://api.github.com/users/patrickByrne99")

#displays number of followers
myData$followers

followers = fromJSON("https://api.github.com/users/patrickByrne99/followers")
followers$login #gives user names of all my followers

myData$following #displays number of people I am following

following = fromJSON("https://api.github.com/users/patrickByrne99/following")
following$login #gives the names of all the people i am following

myData$public_repos #displays the number of repositories I have

repos = fromJSON("https://api.github.com/users/patrickByrne99/repos")
repos$name #Details of the names of my public repositories
repos$created_at #Gives details of the date the repositories were created 
repos$full_name #gives names of repositiories

myData$bio #Displays my bio

lcaRepos <- fromJSON("https://api.github.com/repos/patrickByrne99/CS3012_LCA/commits")
lcaRepos$commit$message #The details I included describing each commit to LCA assignment repository 

#Interrogate the Github API to extract data from another account by switching the username
laurastack9Data = fromJSON("https://api.github.com/users/laurastack9")
laurastack9Data$followers #lists the number of followers kennyc11 has
laurastack9Data$following #lists the number of people kennyc11 is following
laurastack9Data$public_repos #lists the number of repositories they have