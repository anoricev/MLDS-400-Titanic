# Titanic Disaster: MLDS-400 Homework 3

This project trains logistic regression models on the Titanic dataset using both Python and R. It build a public environment that can instruct a user to download the data and run the repository through the terminal in a few simple steps.

## Repository Structure

```
MLDS-400-Titanic/
├── .gitignore
├── CODEOWNERS
├── README.md
├── requirements.txt
├── output/
│   ├── predictions_part3.csv 
│   └── predictions_part4.csv 
│
└── src/
    ├── data/
    │   └── .gitkeep
    │
    ├── Python_codes/
    │   ├── main.py
    │   └── Dockerfile
    │
    └── R_codes/
        ├── main.R
        ├── install_packages.R
        └── Dockerfile
```

## Clone the Repository 

### Use HTTPS

```bash
git clone https://github.com/anoricev/MLDS-400-Titanic.git
cd DataEng_Titanic
```

### Use SSH

```bash
git clone git@github.com:anoricev/MLDS-400-Titanic.git
cd DataEng_Titanic
```

## Get the Data

Download the following two files from the [Kaggle Titanic dataset](https://www.kaggle.com/competitions/titanic/data):

* `train.csv`
* `test.csv`

Place both files into the following folder `src/data/` and you should now have:

```
src/data/train.csv
src/data/test.csv
```

## Run the Python Container

### Build the container and run it

From the repository root:

```bash
docker build -t mlds-400-titanic -f src/Python_codes/Dockerfile .
docker run --rm -v "$PWD/src/data:/app/src/data" mlds-400-titanic
```

### What happens inside

* Reads `src/data/train.csv`
* Drops rows with any missing values
* Creates `IsAlone`
* Trains a logistic regression model using `scikit-learn`
* Reads `src/data/test.csv`
* Generates predictions
* Saves results to: `output/predictions_part3.csv`

## Run the R Container

### Build the container and run it

```bash
docker build -t mlds-400-titanic-r -f src/R_codes/Dockerfile .
docker run --rm -v "$PWD/src/data:/app/src/data" mlds-400-titanic-r
```

### What happens inside

* Reads `src/data/train.csv`
* Drops rows with any missing values
* Creates `IsAlone`
* Trains logistic regression using `glm`
* Reads `src/data/test.csv`
* Generates predictions
* Saves results to `output/predictions_part4.csv`

## Outputs

| File                           | Description                       |
| ------------------------------ | --------------------------------- |
| `output/predictions_part3.csv` | Predictions from the Python model |
| `output/predictions_part4.csv` | Predictions from the R model      |

Each output contains:

* `PassengerId` 
* `Prediction` (0 or 1)

## OPTIONAL: Run Locally Without Docker

### Python

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python src/Python_codes/main.py
```

### R

```bash
Rscript src/R_codes/main.R
```