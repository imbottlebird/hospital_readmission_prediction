# hospital_readmission_prediction
Study hospital readmission risk to assess the impact of telehealth interventions on diabetic patients with the ultimate goal of reducing the 30-day readmission rate.

### 1. Dataset

1.	The dataset includes over 100,000 hospital discharges of over 70,000 diabetic patients from 130 hospitals across the United States during the period 1999 - 2008 . All patients were hospital inpatients for 1 - 14 days, and received both lab tests and medications while in the hospital. The 130 hospitals represented in the dataset vary in size and location: 58 are in the northeast United States and 78 are mid-sized (100 - 499 beds).
2.	The dataset has total 101,766 observations of 45 variables. There are several Factors datatypes in the dataset; race, gender, age, admissionType, and admissionSource;
3.	The variable we are predicting is readmission (INT). The datatype needs to be converted into Factor type to create a CART model for classification, not Regression.
4.	75% of dataset will be used to train the model, and rest 25% will be used to evaluate the accuracy of the model.
