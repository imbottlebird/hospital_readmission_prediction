## Preventing Hospital Readmissions through Telehealth Intervention
Study hospital readmission risk to assess the impact of telehealth interventions on diabetic patients with the ultimate goal of reducing the 30-day readmission rate.

### 1. Dataset

1.	The dataset includes over 100,000 hospital discharges of over 70,000 diabetic patients from 130 hospitals across the United States during the period 1999 - 2008 . All patients were hospital inpatients for 1 - 14 days, and received both lab tests and medications while in the hospital. The 130 hospitals represented in the dataset vary in size and location: 58 are in the northeast United States and 78 are mid-sized (100 - 499 beds).
2.	The dataset has total 101,766 observations of 45 variables. There are several Factors datatypes in the dataset; race, gender, age, admissionType, and admissionSource;
3.	The variable we are predicting is readmission (INT). The datatype needs to be converted into Factor type to create a CART model for classification, not Regression.
4.	75% of dataset will be used to train the model, and rest 25% will be used to evaluate the accuracy of the model.

### 2. Loss mastrix definition for CART model

Given the cost of 30-day unplanned readmission and telehealth intervention are $35,000 and $1,200 respectively, the cost incurred for each possible case is defined as below.
*	Cost of True Negative (TN): 0
*	Cost of False Positive (FP): $1,200
*	Cost of False Negative (FN): $35,000
*	Cost of True Positive (PN): $1,200 + ($35,000 * 0.75) = $27,450

Based on the defined costs above, the values for creating the loss matrix are as below
*	L_FP = FP – TN = $1,200
* L_FN = FN – TP = $7,550

This CART model seeks to minimize out-of-sample misclassification cost.

Cost=(# of FN)× L_FN+(# of FP)× L_FP

<img src="https://latex.codecogs.com/svg.latex?\Large&space;cost=(# of FN) \cdot L_FN + (# of FP) \cdot L_FP" title="cost equation" />

