load_data <- function(name) {
  path <- file.path("src", "data", name)
  if (!file.exists(path)) {
    cat(sprintf("ERROR: %s not found at %s\n", name, path))
    quit(status = 1)
  }
  df <- read.csv(path, stringsAsFactors = FALSE)
  cat(sprintf("Successfully loaded %s!\n", name))
  return(df)
}

cleaned <- function(data) {
  output <- data
  output <- output[complete.cases(output), , drop = FALSE]

  # Add IsAlone = 1 if no family aboard (SibSp + Parch == 0)
  output$IsAlone <- as.integer((output$SibSp + output$Parch) == 0)

  return(output)
}

main <- function() {
  # regression on the training set 
  train <- load_data("train.csv")
  training_output <- cleaned(train)
  cat("Data cleaning: Drop NA values and add 'IsAlone' = 1 if no family aboard\n")

  features <- c("Sex", "Age", "Fare", "IsAlone")
  cat(sprintf("Selected features: %s\n", paste(features, collapse = ", ")))

  # Make Sex as a factor and fit logistic regression
  training_output$Sex <- factor(training_output$Sex, levels = c("female","male"))
  formula <- as.formula("Survived ~ Sex + Age + Fare + IsAlone")
  model <- glm(Survived ~ Sex + Age + Fare + IsAlone, data = training_output, family = binomial())

  prob_train <- predict(model, type = "response")
  pred_train <- ifelse(prob_train > 0.5, 1, 0)
  acc <- mean(pred_train == training_output$Survived)
  cat(sprintf("Training accuracy: %.4f\n\n", acc))

  # regression on the test set 
  test <- load_data("test.csv")
  test_output <- cleaned(test)
  test_output$Sex <- factor(test_output$Sex, levels = c("female","male"))

  prob_test <- predict(model, newdata = test_output, type = "response")
  pred_test <- ifelse(prob_test > 0.5, 1, 0)
  output <- data.frame(PassengerId = test_output$PassengerId, Prediction = pred_test)

  save_path <- file.path("output/predictions_part4.csv")
  write.csv(output, save_path, row.names = FALSE)
  cat(sprintf("Saved predictions to '%s'\n", save_path))
}

if (sys.nframe() == 0) main()
