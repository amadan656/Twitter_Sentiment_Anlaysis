###Packages###
install.packages("twitteR")
install.packages("ROAuth")

###Lbrarys###
library("NLP"
library("twitteR")
library("syuzhet")
library("tm")
library("SnowballC")
library("stringi")
library("topicmodels")
library("syuzhet")
library("twitteR")
library("ROAuth")
library(RColorBrewer)
library("wordcloud")
library(ggplot2)

#twitter authentication
consumer_key <- 'INSERT YOUR CONSUMER KEY'
consumer_secret <- 'INSERT YOUR CONSUMER SECRET KEY'
access_token <- 'INSERT YOUR ACCESS_TOKEN'
access_secret <- 'INSERT YOUR ACCESS SECRET TOKEN'

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


##### SEARCH QUERY #############
tweet <- searchTwitter("YOUR SEARCH QUERY", n=1000,lang = "en")


#convert to dataframe
tweets <- twListToDF(tweet)


#text Only
Tweet_text<- tweets$text

########clean text###############
#convert to lower case
Tweet_text<- tolower(Tweet_text)
# replace blank space & "rt"
Tweet_text<- gsub("rt", "", Tweet_text)
# Replace @UserName
Tweet_text <- gsub("@\\w+", "", Tweet_text)
# Remove punctuation
Tweet_text <- gsub("[[:punct:]]", "", Tweet_text)
# Remove links
Tweet_text <- gsub("http\\w+", "", Tweet_text)
# Remove tabs
Tweet_text <- gsub("[ |\t]{2,}", "", Tweet_text)
# Remove blank spaces at the beginning
Tweet_text <- gsub("^ ", "", Tweet_text)
# Remove blank spaces at the end
Tweet_text <- gsub(" $", "", Tweet_text)

### SENTIMENT ANALYSIS ###
        
mysentiment_Tweet<-get_nrc_sentiment((Tweet_text))

Sentimentscores_Tweet<-data.frame(colSums(mysentiment_Tweet[,]))

names(Sentimentscores_Tweet)<-"Score"
Sentimentscores_Tweet<-cbind("sentiment"=rownames(Sentimentscores_Tweet),Sentimentscores_Tweet)
rownames(Sentimentscores_Tweet)<-NULL

ggplot(data=Sentimentscores_Tweet,aes(x=sentiment,y=Score))+geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("scores")+ggtitle("Sentiments of people behind tweets")


Tweet_text$mysentiment_tweets


# Wordcloud generator
wordcloud(Tweet_text,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 100)

