###Packages###
install.packages("twitteR")
install.packages("ROAuth")

###Lbrarys###

library("twitteR")
library("syuzhet")
library("twitteR")
library("ROAuth")
library("RColorBrewer")
library("wordcloud")


#twitter authentication
consumer_key <- 'INSERT YOUR CONSUMER KEY'
consumer_secret <- 'INSERT YOUR CONSUMER SECRET KEY'
access_token <- 'INSERT YOUR ACCESS_TOKEN'
access_secret <- 'INSERT YOUR ACCESS SECRET TOKEN'

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

##### SEARCH QUERY #############
search <- searchTwitter("SEARCH QUERY", n=1000,lang = "en")


#convert to dataframe
tweets <- twListToDF(search)



#text Only
tweet_text<- tweets$text


########clean text###############
#convert to lower case
tweet_text<- tolower(syfy_text)
# replace blank space & "rt"
tweet_text <- gsub("rt", "", syfy_text)
# Replace @UserName
tweet_text <- gsub("@\\w+", "", syfy_text)
# Remove punctuation
tweet_text <- gsub("[[:punct:]]", "", syfy_text)
# Remove links
tweet_text <- gsub("http\\w+", "", syfy_text)
# Remove tabs
tweet_text <- gsub("[ |\t]{2,}", "", syfy_text)
# Remove blank spaces at the beginning
tweet_text <- gsub("^ ", "", syfy_text)
# Remove blank spaces at the end
tweet_text <- gsub(" $", "", syfy_text)


###Sentiment Analysis###

tweet_sentiment<-sentiment(tweet_text)

tweet_sentimentscores<-data.frame(colSums(tweet_sentiment[,]))

names(tweet_sentimentscores)<-"Score"
tweet_sentimentscores<-cbind("sentiment"=rownames(tweet_sentimentscores),tweet_sentimentscores)
rownames(tweet_sentiment)<-NULL



# Join Tables

tweets_df <- data.frame(tweet_text, tweet_sentiment=tweet_sentiment, tweet_sentimentscores=tweet_sentimentscores, stringsAsFactors = FALSE)


merge<-cbind(tweets_df,tweets)

#Select Columns

Final_Table <- select(merge,"created","tweet_text","tweet_sentiment.word_count","tweet_sentiment.sentiment","favoriteCount","isRetweet","retweetCount")

# Export as CSV
write.csv(Final_Table, file = 'Twitter_Scrape.csv')


# Wordcloud generator
wordcloud(tweet_text,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 100)

