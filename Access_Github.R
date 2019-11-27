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
nelsonicData = fromJSON("https://api.github.com/users/laurastack9")
nelsonicData$followers #lists the number of followers 
nelsonicData$following #lists the number of following
nelsonicData$public_repos #lists the number of repositories 






myData = GET("https://api.github.com/users/nelsonic/followers?per_page=100;", gtoken)
stop_for_status(myData)
extract = content(myData)
#converts into dataframe
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login

# Gets a list of usernames
id = githubDB$login
user_ids = c(id)

# Makes empty vector and data.frame
users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

#loops through users and adds to list
for(i in 1:length(user_ids))
{
  
  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  #Leaves out users with 0 followers
  if(length(followingContent) == 0)
  {
    next
  }
  
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  #Loop through users following
  for (j in 1:length(followingLogin))
  {
    #Check for double up of users
    if (is.element(followingLogin[j], users) == FALSE)
    {
      #Adds user to the current list
      users[length(users) + 1] = followingLogin[j]
      
      #Obtain information from each user
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #Who user is following
      followingNumber = followingDF2$following
      
      #Users followers
      followersNumber = followingDF2$followers
      
      #Their number of repository 
      reposNumber = followingDF2$public_repos
      
      #Year which each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 10 users
  if(length(users) > 150)
  {
    break
  }
  next
}
#Use plotly to graph
Sys.setenv("plotly_username"="patrickByrne99")
Sys.setenv("plotly_api_key"="Bm7lfs63dzZm5LdzvaQg")

#plot one graphs repositories vs followers coloured by year
plot1 = plot_ly(data = usersDB, x = ~repos, y = ~followers, text = ~paste("Followers: ", followers, "<br>Repositories: ", repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plot1

#sending first plot to plotly
api_create(plot1, filename = "Repositories vs Followers")

#plot two graphs following vs followers again coloured by year
plot2 = plot_ly(data = usersDB, x = ~following, y = ~followers, text = ~paste("Followers: ", followers, "<br>Following: ", following), color = ~dateCreated)
plot2

#sends second plot to plotly
api_create(plot2, filename = "Following vs Followers")


