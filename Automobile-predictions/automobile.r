# 
# Final Project for MGSC662 Fall 2022
# 
# @author: Shanshan Lao 
# 
# Problem Statement: Shat characteristics of a car would affect its safety level
# 


# Step 0. import all necessary libraries =========================================
if (!require("pacman")) install.packages("pacman")
pacman::p_load(pacman, 
               readr,        #for reading file
               ggplot2,      #for plotting
               dplyr,        #for data manipulation %>%
               ggfortify,    #for pca visualization
               psych,        #for correlation matrix cor()
               randomForest, #for building random forest
               MASS,klaR,    #for Linear Discriminant Analysis
               tidyr,        #for drop_na()
               tree,rpart,
               rpart.plot,   #for building trees
               stargazer,    #for formatting
               gbm,          #for boosting
               rms,          #for R-squared
               caTools,      #for sample.split()
               randomForestExplainer,
               car,         #for outlierTest
               plyr,        # for join()
               #boot,        #for cv.glm()
               hash         #for hash table
)

# Step 1. Data Pre-processing ================================================
auto_original <- read_csv("Dataset 5 — Automobile data.csv")

#first understand the data 
summary(auto_original)

#transform the columns to its correct data type
#missing values are transformed to NA
#transform 'symboling' to binary target 'is_risky'
auto <- auto_original %>%
  na_if(., "?") %>%                       #replace ? with NA
  dplyr::mutate(across(c(`normalized-losses`, bore, stroke, 
                         horsepower, `peak-rpm`, price), as.numeric)) %>%
  dplyr::rename(is_risky = symboling) %>%
  dplyr::mutate(is_risky = ifelse(is_risky > 0,1,0)) %>%
  dplyr::mutate(across(c(is_risky), as.character)) %>%
  mutate_if(is.character, as.factor)      # Convert character column to factor

  
# check the current data type
sapply(auto,class)


## Handling missing values  ---------------
### First to check how many missing values in each column
rowSums(is.na(auto)) # no. missing values for each observation
colSums(is.na(auto)) # no. missing values for each variable

### Drop `normalized-losses` as it has too many missing values
auto = auto[-2]
summary(auto)

# Replace price with avg per make
miss_price = which(is.na(auto$price))
avg_price = aggregate(auto$price, list(auto$make), FUN=mean, na.rm=TRUE)
for (i in miss_price){
  brand = sapply(auto[i,"make"], as.character)
  auto[i,"price"] = avg_price$x[avg_price$Group.1 == brand]
}

# Drop the rest na
auto = drop_na(auto)

summary(auto)
attach(auto)

col_names = colnames(auto)


# Step 2. Individual Exploration ===============================================

## 2.1. Visualizing distribution ----------------------------
for (col in col_names) {
  if(is.numeric(unlist(auto[col]))) {
    # boxplot 
    picname_boxplot <- sprintf("./graphs/num_boxplot_%s.png",col)
    png(file = picname_boxplot,width=600,height=600)
    boxplot(auto[col],xlab=col,cex.lab=1.5)
    dev.off()
    
    # histogram 
    picname_hist <- sprintf("./graphs/num_histogram_%s.png",col)
    png(file = picname_hist,width=600,height=600)
    hist(unlist(auto[col]),xlab=col,cex.lab=1.5,
         main = paste("Histogram of", col))
    dev.off()
  } else { 
    # barplox for all categorical data
    picname_boxplot <- sprintf("./graphs/cat_barplot_%s.png",col)
    png(file = picname_boxplot,width=1000,height=800)
    barplot(table(auto[col]))
    dev.off()
  }
}

       
## 2.2 Relationship between variables --------------

# Scaling
quantVars <- names(select_if(auto, is.numeric))
auto[quantVars] <- scale(auto[quantVars])
summary(auto)
attach(auto)

# Identify Collinearity
corr_matrix = round(cor(auto[quantVars]),3)
corr_matrix[corr_matrix > 0.8 & corr_matrix < 1]
write.csv(as.data.frame(corr_matrix),"./corr_matrix.csv")


# Using PCA Analysis
pca = prcomp(auto[quantVars],scale=TRUE)
autoplot(pca, data=auto[quantVars], loadings=TRUE, loadings.label=TRUE)

write.csv(as.data.frame(pca$rotation),"./pca.csv")


# Relationship between numeric predictors and target
for (col in col_names) {
  if(is.numeric(unlist(auto[col]))) {
    picname_pdf <- sprintf("./graphs/isRisky_%s.png",col)
    png(file = picname_pdf,width=800,height=1000)
    p <- ggplot(auto, aes(x=unlist(auto[col])))+geom_histogram(bins=30)+facet_grid(is_risky)+xlab(col)
    print(p)
    dev.off()
  }
}



# Step 2.5 Data modification =========================================

## 2.5.1 Run a Random Forest to see importance ---------------------
Feature_Importance = randomForest(is_risky~.,cp=0.01,data=auto,
                      importance=TRUE,na.action=na.omit, do.trace=50)

### The higher the value, the higher the importance
imp = as.data.frame(importance(Feature_Importance))
sorted_imp = imp[order(-imp$MeanDecreaseAccuracy),]
rownames(sorted_imp)

### visualize the importance
png(file = sprintf("./graphs/_FeatureImp.png"),width=1200,height=600)
print(varImpPlot(Feature_Importance))
dev.off()
write.csv(varImpPlot(Feature_Importance),"./featureImp.csv")

## 2.5.2 CONCLUSION and data modification ------------------------------

### -- Variables with sorted feature importance -- #
### "make", "num-of-doors", "wheel-base", "height", "length","body-style", 
### "width", "curb-weight", "peak-rpm", "bore", "stroke", "horsepower",
### "price", "engine-size", "fuel-system", highway-mpg", "city-mpg","drive-wheels"
### "compression-ratio","engine-type","num-of-cylinders","aspiration","fuel-type","engine-location" 


### -- Observations from the distribution -- ###
### Categorical variables with unequal distribution:
###   - 98.5% engine locates in the front  => drop engine-locations
###   - 90.6% fuel type is gas             => drop fuel-type
###   - 81.7% aspiration is std            => drop aspiration
###   - 78.7% "num-of-cylinders" is four   => reclassify: four & others
###   - 73.1% engine type is ohc           => reclassify: ohc & others
###   - fuel-system, make

### -- Observations from the pca plot -- ### 
### Variables that represents the maximum Variance.
###   - curb-weight, length, width, engine-size
### Highly correlated variables:
###   - highway-mpg & city-mpg, => drop highway-mpg
###   - price & engine-size,    => drop price
####  - bore & engine-size,     => drop bore
###   - curb-weight & width,    => drop width
###   - length & width,
###   - wheel-base & stroke,    => drop stroke


make_few = names(table(auto$make)[table(auto$make)<10])
fuel_few = names(table(auto$`fuel-system`)[table(auto$`fuel-system`)<10])

auto_clas <- auto %>%
  dplyr::select(-c("engine-location", "fuel-type", "aspiration",
                   "highway-mpg", "price", "bore", "width", "stroke")) %>%
  mutate(`num-of-cylinders` = as.factor(
    replace(x = as.character(auto$`num-of-cylinders`),
            list= !auto$`num-of-cylinders` %in% c("four","six"), 
            values="other")) ) %>%
  mutate(`engine-type` = as.factor(
    replace(x = as.character(auto$`engine-type`),
            list= !auto$`engine-type` %in% c("ohc"), 
            values="other")) ) %>%
  mutate(`fuel-system` = as.factor(
    replace(x = as.character(auto$`fuel-system`),
            list= auto$`fuel-system` %in% fuel_few, 
            values="other")) ) %>%
  mutate(make = as.factor(
    replace(x = as.character(auto$make),
            list= auto$make %in% make_few, 
            values="other")) ) #%>%
  #dplyr::select(-c("num-of-cylinders","engine-type"))


attach(auto_clas)

# Step 3. Model Selection ==================================================

# first use all data to create the model to find outlier
model_logit = glm(is_risky~., family="binomial", data=auto_clas)
out = as.numeric(names(outlierTest(model_logit)$p)) 
auto_clean = auto_clas[-c(out),]
attach(auto_clean)

log_accuracy = vector(mode="numeric", length=30)
dt_accuracy = vector(mode="numeric", length=30)
rf_accuracy = vector(mode="numeric", length=30)

for (i in c(1:30)){
  sample = sample.split(auto_clean$is_risky, SplitRatio=0.75)
  train_set = subset(auto_clean, sample == TRUE)
  test_set = subset(auto_clean, sample == FALSE)
  attach(train_set)
  
  ## Logistic Regression ------------
  model_logit = glm(is_risky~., family="binomial", data=train_set)
  pred_log = predict(model_logit, test_set, type="response")
  log_accuracy[i] = sum(round(pred_log) == test_set$is_risky)/nrow(test_set) 
  
  
  
  ## Decision Tree ----------------
  model_tree = rpart(is_risky~.,data=train_set, cp=0.001,
                     method="class",na.action=na.omit)
  #rpart.plot(model_tree)
  pred_dt = predict(model_tree, newdata=test_set, type="class") 
  dt_accuracy[i] = sum(pred_dt == test_set$is_risky)/nrow(test_set) 
  
  
  
  ## Random Forest -----------
  model_forest  = randomForest(is_risky~.,cp=0.001,data=train_set,
                               importance=TRUE,na.action=na.omit, do.trace=50)
  pred_rf = predict(model_forest, test_set, type="class")
  rf_accuracy[i] = sum(pred_rf == test_set$is_risky)/nrow(test_set)
  
}

log_avg = mean(log_accuracy, na.rm=TRUE)
dt_avg = mean(dt_accuracy)
rf_avg = mean(rf_accuracy)



## Further tuning
attach(auto_clas)
model_forest=randomForest(is_risky~.,ntree=500,data=auto_clas,
                            importance=TRUE,na.action=na.omit, do.trace=50)
varImpPlot(model_forest)
model_forest

randomForest::getTree(model_forest)
attach(auto_clas)
plot(randomForest(is_risky~., auto_clas, keep.forest=FALSE, ntree=500), 
     log="y", main="Out-of-Bag Error")


