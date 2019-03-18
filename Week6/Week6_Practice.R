# 30th/Oct./2018 Text mining with R

install.packages("tm")
library(tm)

setwd("C:/Users/Eric Huang/Documents/University of Sheffield/MSc Data Science/01. INF6027 Introduction to Data Science/04. Project Document for R/Datasets")
getwd()
docs = Corpus(DirSource("./texts", encoding = "UTF-8"))

summary(docs)
inspect(docs[1])
docs[[1]]
docs[[1]]$meta
docs = tm_map(docs, content_transformer(tolower)) # convert to lowercase
docs[[1]]$content

docs = tm_map(docs, removeWords, stopwords("en")) # remove stopword by language
docs[[1]]$content

trumpDTM = DocumentTermMatrix(docs)
trumpDTM
View(inspect(trumpDTM))
inspect(trumpDTM[, 1:2])

inspect(trumpDTM[, c("news", "fake", "america","great")])

trumpDTMFreq = findFreqTerms(trumpDTM, lowfreq = 0) # filter the Document Term Matrix by frequence of term
inspect(trumpDTM$dimnames$Terms)
trumpFreqTerms = colSums(as.matrix(trumpDTM)) # return a named vactor
trumpFreqTerms = sort(trumpFreqTerms, decreasing = TRUE)

trumpDF = data.frame(Word = names(trumpFreqTerms), Frequency = trumpFreqTerms)
library(dplyr)
arrange(trumpDF, desc(Frequency))

# draw a bar chart for the terms which frequency > 100
over100 = subset(trumpDF, trumpDF$Frequency >100)
library(ggplot2)
ggplot(over100, aes(x = reorder(Word, -Frequency), y = Frequency)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# draw a wordcloud for the terms
install.packages("wordcloud")
library(wordcloud)
set.seed(142)
wordcloud(trumpDF$Word, trumpDF$Frequency, min.freq = 25)

# to calculate the co-occur relationships among word and terms
findAssocs(trumpDTM, "fake", corlimit = 0.95)

# alternative for text mining by tidytext
installed.packages("tidytext")
library(tidytext)
library(janeaustenr)
library(dplyr)
library(ggplot2)
library(stringr)

View(austen_books())

# summarise the total lines of each book
austen_books() %>% 
  group_by(by = book) %>%
  summarise(Total_line = n())

# unnest the text into word columns
austenTidyBooks = austen_books() %>% unnest_tokens(word, text)

# count words 
wordCount = austenTidyBooks %>% count(word, sort = TRUE)

# remove stopwords by anti_join
data("stop_words")
austenTidyBooks = austenTidyBooks %>% anti_join(stop_words)
  
wordCount2 = austenTidyBooks %>% count(word, sort = TRUE)

austenTidyBooks %>% filter(book == "Emma") %>% count(word, sort = TRUE)
austenTidyBooks %>% filter(book == "Sense & Sensibility") %>% count(word, sort = TRUE)

data("sentiments")
get_sentiments("nrc") %>%
  group_by(by = sentiment) %>%
  summarise(count = n())

nrcAnger = get_sentiments("nrc") %>% filter(sentiment == "anger")
austenTidyBooks %>% 
  filter(book == "Emma") %>% 
  inner_join(nrcAnger) %>% 
  count(word, sort = TRUE)

austenTidyBooks %>% 
  filter(book == "Emma") %>% 
  inner_join(get_sentiments("nrc")) %>%
  group_by(by = sentiment) %>%
  summarise(percent = (n()/34141)*100)

library(reshape2)
austenTidyBooks %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 150)

# create a data frame which binds tf / idf / tf_idf
austenTFIDF = austenTidyBooks %>%
  count(book, word, sort = TRUE) %>%
  bind_tf_idf(word, book, n) %>%
  arrange(desc(tf_idf))

# create a diagram showing 12 top terms among each books
austenTFIDF %>%
  group_by(by = book) %>%
  top_n(12, tf_idf) %>%
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(word, tf_idf, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, scales = "free") +
  ylab("tf-idf") +
  coord_flip()

# convert the document term matrix to data frane by tidyverse
trumpTidy = tidy(trumpDTM)

# inner join with sentiments where trumpTidy.term = get_sentiments("bing").word
# then drawing a text cloud
sentTrump = trumpTidy %>%
  inner_join(get_sentiments("bing"), by = c(term = "word")) %>%
  count(term, sentiment, sort = TRUE) %>%
  acast(term ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 150)

