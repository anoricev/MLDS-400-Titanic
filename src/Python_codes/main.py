import os
import sys
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

def load_data(name):
    path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "data", name)
    try:
        df = pd.read_csv(path)
        print(f"Successfully loaded {name}!")
    except FileNotFoundError:
        print(f"ERROR: {name} not found")
        sys.exit(1)
    return df

def cleaned(data):
    output = data.copy().dropna()
    output["IsAlone"] = ((output["SibSp"] + output["Parch"]) == 0).astype(int)
    return output

def main():
    # regression on the training set 
    train = load_data("train.csv")
    training_output = cleaned(train)
    print("Data cleaning: Drop NA values and add a variable 'IsAlone' = 1 if no family aboard")

    features = ["Sex", "Age", "Fare", "IsAlone"]
    print(f"Selected features: {features}")

    x_train = training_output[features]
    y_train = training_output["Survived"]
    x_train = pd.get_dummies(x_train, columns=["Sex"], drop_first=True)
    model = LogisticRegression(max_iter=1000)
    model.fit(x_train, y_train)
    y_pred_train = model.predict(x_train)
    acc = accuracy_score(y_train, y_pred_train)
    print(f"Training accuracy: {acc:.4f}\n")

    # regression on the test set
    test = load_data("test.csv")
    test_output = cleaned(test)
    x_test = test_output[features]
    x_test = pd.get_dummies(x_test, columns=["Sex"], drop_first=True)
    output = pd.DataFrame({"Passenger ID": test_output["PassengerId"], "Prediction": model.predict(x_test)})
    output.to_csv("output/predictions_part3.csv", index=False)
    print(f"Saved predictions to 'predictions_part3.csv'")

if __name__ == "__main__":
    main()
