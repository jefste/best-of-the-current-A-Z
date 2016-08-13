#Load XML library. This is needed to scrape web.
library(XML)
#used for piping
library(dplyr)
#http://www.thecurrent.org/playlist/2016-07-01/10


#starting day is 7/1 at 10 AM
#first hour of the day is 0 and goes to 23
url.to.grab<-""
#initalize list
alpha.list<-data.frame(title=character(0),artist=character(0))


for(day in 1:4)
  {
  hours<-0:23
  if(day==1) #first day starts at 10 AM
    { 
    hours<-10:23
  }
  if(day==4) # last day goes until 10 PM
  {
    hours<-0:21
  }
  
  for(hour in hours) 
    {
    #build up th url to grab for each hour
    url.to.grab<-paste0('http://www.thecurrent.org/playlist/2016-07-0',day,'/',hour)
    #grab html for that hour of the day
    grabHTML<-htmlTreeParse(url.to.grab,useInternalNodes = T)
    #grab all artists & titles that fall in the data-hour div
    #use // for div to seach entire page, use // for h5 to search everywhere in div
    artist.temp<-xpathSApply(grabHTML, paste0("//div[@data-hour='",hour,"']//h5[@class='artist']"), xmlValue)
    title.temp<-xpathSApply(grabHTML, paste0("//div[@data-hour='",hour,"']//h5[@class='title']"), xmlValue)
    #revese the order of each list
    artist.temp<-rev(artist.temp)
    title.temp<-rev(title.temp)
    #bind the columns for a particular hour, then bind them to the running list
    alpha.list<-rbind(alpha.list,cbind(title.temp,artist.temp))
    }
}
tail(alpha.list,15)
head(alpha.list,15)

alpha.list<-alpha.list[-1249,] #remove track after ziggy stardust

#get rid of extra commas in title or artist
alpha.list$title.temp<-gsub(",","",alpha.list$title.temp)
alpha.list$artist.temp<-gsub(",","",alpha.list$artist.temp)
#add a column called playlist
alpha.list$playlist<-"current A-Z best of library"
#rename columns
colnames(alpha.list)<-c("title","artist","playlist")
#export list A-Z
write.csv(alpha.list,"current_A-Z_track_list_ordered.csv",row.names = F)
#export list A-L
write.csv(alpha.list[1:664,],"current_A-L_Best_of.csv",row.names = F)
#export list M-z
write.csv(alpha.list[665:1248,],"current_M-Z_Best_of.csv",row.names = F)


