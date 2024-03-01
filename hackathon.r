library(dbscan)
library(tm)
library(textTinyR)
library(jsonlite)
json_content <- paste(readLines("C:/hindu/remark.json"), collapse = "\n")
json_data <- jsonlite::fromJSON(json_content )
#json_data <- fromJSON("C:/hindu/remark.json")
data <- as.data.frame(json_data)
print(data)
corpus <- Corpus(VectorSource(data$Text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)
dtm <- DocumentTermMatrix(corpus)
text_matrix <- as.matrix(dtm)
combined_data <- cbind(text_matrix, Department = data$Department)
dbscan_result <- dbscan(text_matrix, eps = 0.5, MinPts = 2)
data$Cluster <- dbscan_result$cluster
print(data)
