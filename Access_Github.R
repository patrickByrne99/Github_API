#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
library(plotly)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

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


#Linking to my PlotLy Account
Sys.setenv("plotly_username"="patrickByrne99")
Sys.setenv("plotly_api_key"="Bm7lfs63dzZm5LdzvaQg")

#FUNCTIONS--------------------------------------------------------------------------------------
#Number of followers
#I assigned some frequently used strings variable names to make my code neater
userslink = "https://api.github.com/users/"
followerslink = "/followers"
followinglink = "/following"
perpagelink = "?per_page="

numFollowers = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  
  num_followers = user$followers
  return(num_followers)
}

#A list of users followers
followers = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username, followerslink))
  list = user$login
  return(list)
}

#How many people the user is they Following? 
numFollowing = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  num_following = user$following
  return(num_following)
}

#List of above
following = function(username)
{
  userfol = jsonlite::fromJSON(paste0(userslink, username, followinglink))
  list = userfol$login
  return(list)
}

#Location
location = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  location = user$location
  return(location)
}

#Account created
dateCreated = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  created = substring(toString(user$created_at), 1, 10)
  return(created)
}

#Last activity
lastActive = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  updated = substring(toString(user$updated_at), 1, 10)
  return(updated)
}

#Public Repositories Count
numRepos = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  num = user$public_repos
  return(num)
}

#List of repositories
listRepos = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  list = jsonlite::fromJSON(user$repos_url)$name
  
  return(list)
}

#Languages of these repositories 
listLanguages = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  list = jsonlite::fromJSON(user$repos_url)$language
  
  
  list = list[!is.na(list)]
  return(list)
}

