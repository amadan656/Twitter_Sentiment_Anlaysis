install.packages("twitteR")
install.packages("ROAuth")
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
consumer_key <- 'qy84bDNH3P5uk532PWnzuXckF'
consumer_secret <- 'wire4O1NGJJGk4w8TabJOdEikQkW6SaI3fKffHsaI3WaExb5pI'
access_token <- '1067072972450660353-DD5phg1crOYSxDRDLFdd3EqBzBBcpL'
access_secret <- 'cv98QhgOXMUY1Ztz3u2FwQfoif9ikOXg8TxLeXqtVnxGG'

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


##### SEARCH QUERY #############
tweets_s <- searchTwitter("#syfy", n=1000,lang = "en")


#convert to dataframe
syfy_tweets <- twListToDF(tweets_s)


#text Only
syfy_text<- syfy_tweets$text

########clean text###############
#convert to lower case
syfy_text<- tolower(syfy_text)
# replace blank space & "rt"
syfy_text <- gsub("rt", "", syfy_text)
# Replace @UserName
syfy_text <- gsub("@\\w+", "", syfy_text)
# Remove punctuation
syfy_text <- gsub("[[:punct:]]", "", syfy_text)
# Remove links
syfy_text <- gsub("http\\w+", "", syfy_text)
# Remove tabs
syfy_text <- gsub("[ |\t]{2,}", "", syfy_text)
# Remove blank spaces at the beginning
syfy_text <- gsub("^ ", "", syfy_text)
# Remove blank spaces at the end
syfy_text <- gsub(" $", "", syfy_text)

mysentiment_syfy<-get_nrc_sentiment((syfy_text))

Sentimentscores_syfy<-data.frame(colSums(mysentiment_syfy[,]))

names(Sentimentscores_syfy)<-"Score"
Sentimentscores_syfy<-cbind("sentiment"=rownames(Sentimentscores_syfy),Sentimentscores_syfy)
rownames(Sentimentscores_syfy)<-NULL

ggplot(data=Sentimentscores_syfy,aes(x=sentiment,y=Score))+geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("scores")+ggtitle("Sentiments of people behind the tweets on Syfy")


syfy_text$mysentiment_syfy


# Wordcloud generator
wordcloud(syfy_text,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 100)

