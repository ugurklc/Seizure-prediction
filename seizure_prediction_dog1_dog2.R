#install.packages('foreach')
#install.packages('ggplot2')
#install.packages('ggthemes')
#install.packages('dplyr')
#install.packages('corrgram')
#install.packages('corrplot')
#install.packages('caret')
#install.packages('pROC')
library(ggplot2)
library(ggthemes)
library(dplyr)
library(corrgram)
library(corrplot)
library(reshape2)
library(MASS)
library(caTools)
library(caret)
library(pROC)




# Set the working directory where all the csv files are located
setwd("/Users/ugurkilic/Documents/Box Sync/0  2018-Fall/Machine Learning/Project/features943")


dog1 <- read.csv("dog1.feat.txt", header = FALSE)

dog1.interictal.feat <- dog1[1:480,]
dog1.preictal.feat <- dog1[481:504,]
dog1.test.feat <- dog1[505:1006,]

dog2 <- read.csv("dog2.feat.txt", header = FALSE)

dog2.interictal.feat <- dog2[1:500,]
dog2.preictal.feat <- dog2[501:542,]
dog2.test.feat <- dog2[543:1542,]

# Add zeros as labeled column for interictal and add ones for preictal
dog1.interictal.feat$Label <- rep(0,nrow(dog1.interictal.feat))
dog1.preictal.feat$Label <- rep(1,nrow(dog1.preictal.feat))

dog1.int.pre <- rbind(dog1.interictal.feat , dog1.preictal.feat)
dog2.int.pre <- rbind(dog2.interictal.feat , dog2.preictal.feat)

# Train and Test sets split
dog1.sample.size <- floor(0.7*nrow(dog1.int.pre))
dog1.train.index <- sample(seq_len(nrow(dog1.int.pre)), size = dog1.sample.size)
dog1.train <- dog1.int.pre[dog1.train.index,]
dog1.test <- dog1.int.pre[-dog1.train.index,]

dog2.sample.size <- floor(0.7*nrow(dog2.int.pre))
dog2.train.index <- sample(seq_len(nrow(dog2.int.pre)), size = dog2.sample.size)
dog2.train <- dog2.int.pre[dog2.train.index,]
dog2.test <- dog2.int.pre[-dog2.train.index,]


# Logistic Model
dog1.model <- glm(Label ~ . , family = binomial(link = 'logit'), data = dog1.train)
dog2.model <- glm(V944 ~ . , family = binomial(link = 'logit'), data = dog2.train)


dog1.test$predict.seizure <- predict(dog1.model, newdata = dog1.test, type = 'response')
dog2.test$predict.seizure <- predict(dog2.model, newdata = dog2.test, type = 'response')

dog1.test$predict.dog1.with.dog2.model <- predict(dog2.model, newdata = dog1.test, type = 'response')
dog2.test$predict.dog2.with.dog1.model <- predict(dog1.model, newdata = dog2.test, type = 'response')

table(dog1.test$Label, dog1.test$predict.seizure>0.5)
table(dog2.test$V944, dog2.test$predict.seizure>0.5)

table(dog1.test$Label, dog1.test$predict.dog1.with.dog2.model>0.5)
table(dog2.test$V944, dog2.test$predict.dog2.with.dog1.model>0.5)

dog1.with.dog2.model.acc <- (73+3)/152
dog1.with.dog2.model.acc
dog2.with.dog1.model.acc <- (124/163)
dog2.with.dog1.model.acc

dog1.logit_coeff = coef(summary(dog1.model))
dog1.ranked_params = row.names(dog1.logit_coeff)[order(abs(dog1.logit_coeff[,"z value"]), decreasing=T)]
dog1.ranked_params = dog1.ranked_params[!(dog1.ranked_params %in% "(Intercept)")]
dog1.ranked_params

dog2.logit_coeff = coef(summary(dog2.model))
dog2.ranked_params = row.names(dog2.logit_coeff)[order(abs(dog2.logit_coeff[,"z value"]), decreasing=T)]
dog2.ranked_params = dog2.ranked_params[!(dog2.ranked_params %in% "(Intercept)")]
dog2.ranked_params

roccurve <- roc(dog1.test$Label ~ dog1.test$predict.seizure)
roccurve2 <- roc(dog2.test$V944 ~ dog2.test$predict.seizure)
roccurve3 <- roc(dog1.test$Label ~ dog1.test$predict.dog1.with.dog2.model)
roccurve4 <- roc(dog2.test$V944 ~ dog2.test$predict.dog2.with.dog1.model)

plot(roccurve, col = 2, lty = 1, main = "ROC", xlim=c(1, 0), ylim=c(0, 1))
plot(roccurve2, col = 3, lty = 1, add = TRUE)
plot(roccurve3, col = 4, lty = 1, add = TRUE)
plot(roccurve4, col = 5, lty = 1, add = TRUE)

legend(0.4, 0.25, legend=c("Dog_1", "Dog_2", "Dog_1_with_dog_2_model", "Dog_2_with_dog_1_model"), col=c(2,3,4,5), lty=1:2, cex=0.8)

