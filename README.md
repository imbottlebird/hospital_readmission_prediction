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
*	<img src="https://latex.codecogs.com/svg.image?\small&space;L_{FP}=FP&space;-&space;TN&space;=&space;\$1,200&space;" title="https://latex.codecogs.com/svg.image?\small L_{FP}=FP - TN = \$1,200 " />
* <img src="https://latex.codecogs.com/svg.image?\small&space;L_{FN}=FN&space;-&space;TP&space;=&space;\$7,550" title="https://latex.codecogs.com/svg.image?\small L_{FN}=FN - TP = \$7,550" />

This CART model seeks to minimize out-of-sample misclassification cost.

<img src="https://latex.codecogs.com/svg.image?cost&space;=&space;(\sharp\:&space;\:&space;of&space;\:&space;\:&space;FN)\times&space;L_{FN}&plus;(\sharp\:&space;\:&space;of\:&space;\:&space;FP)&space;\times&space;L_{FP}" title="https://latex.codecogs.com/svg.image?cost = (\sharp\: \: of \: \: FN)\times L_{FN}+(\sharp\: \: of\: \: FP) \times L_{FP}" />

### 3. CART model (cp = 0.001; loss matrix defined in section 2)
<img width="430" alt="image" src="https://user-images.githubusercontent.com/55460693/162591647-932c0158-0f78-4c13-9464-c4737297c39e.png">

### 4. Assessment of the model predictive performance
Performance of 30-day unplanned readmissions using the test set

<img width="775" alt="image" src="https://user-images.githubusercontent.com/55460693/162591788-90f902a9-b7c3-4cb4-9799-bb754be1dc07.png">


The column of table indicates the predicted values and the row indicates the actual values. The telehealth intervention is not practiced in Current Practice, hence the values in column ‘1’ are all set to ‘0’ as a default stage.

New Model predicts the number of patients in the column ‘1’ who are likely to readmit to hospital within the 30 days from the period of discharge. The predications are conducted based on the CART model that incorporates the cost of readmission and telehealth intervention defined in the loss matrix.

