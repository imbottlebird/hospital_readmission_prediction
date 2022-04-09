## Preventing Hospital Readmissions through Telehealth Intervention
Study hospital readmission risk to assess the impact of telehealth interventions on diabetic patients with the ultimate goal of reducing the 30-day readmission rate.

#### 1. Dataset

1.	The dataset includes over 100,000 hospital discharges of over 70,000 diabetic patients from 130 hospitals across the United States during the period 1999 - 2008 . All patients were hospital inpatients for 1 - 14 days, and received both lab tests and medications while in the hospital. The 130 hospitals represented in the dataset vary in size and location: 58 are in the northeast United States and 78 are mid-sized (100 - 499 beds).
2.	The dataset has total 101,766 observations of 45 variables. There are several Factors datatypes in the dataset; race, gender, age, admissionType, and admissionSource;
3.	The variable we are predicting is readmission (INT). The datatype needs to be converted into Factor type to create a CART model for classification, not Regression.
4.	75% of dataset will be used to train the model, and rest 25% will be used to evaluate the accuracy of the model.

#### 2. Loss mastrix definition for CART model

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

```bash
#CART model with cp=0.001
readm.mod = rpart(readmission ~ .,
                  data = readm.train, 
                  method = "class", 
                  cp=0.001)
prp(readm.mod)

#predict the readmission
pred <- predict(readm.mod, newdata = readm.test, type = "class")

#confusion matrix. first arg=row, second arg=col - ex. [row,col]
confusion.matrix = table(readm.test$readmission, pred)
confusion.matrix

#define the loss matrix for CART Model
LossMatrix = matrix(0,2,2)
LossMatrix[2,1] = 1200
LossMatrix[1,2] = 7550
#the final table:
LossMatrix
```

**Screenshot of loss matrix in R**

<img width="150" alt="image" src="https://user-images.githubusercontent.com/55460693/162591979-de3f1114-e92d-4454-bd54-77bee1a6f3fd.png">



#### 3. CART model (cp = 0.001; loss matrix defined in section 2)
<img width="600" alt="image" src="https://user-images.githubusercontent.com/55460693/162591647-932c0158-0f78-4c13-9464-c4737297c39e.png">

```bash
readm.mod.2 = rpart(readmission~.,
                  data = readm.train,
                  parms=list(loss=LossMatrix),
                  cp=0.001)

prp(readm.mod.2, digits=3)
```

#### 4. Assessment of the model predictive performance
Performance of 30-day unplanned readmissions using the test set

<ins>Predictive Performance:</ins>

<img width="500" alt="image" src="https://user-images.githubusercontent.com/55460693/162591788-90f902a9-b7c3-4cb4-9799-bb754be1dc07.png">

The column of table indicates the predicted values and the row indicates the actual values. The telehealth intervention is not practiced in Current Practice, hence the values in column ‘1’ are all set to ‘0’ as a default stage.

*New Model* predicts the number of patients in the column ‘1’ who are likely to readmit to hospital within the 30 days from the period of discharge. The predications are conducted based on the CART model that incorporates the cost of readmission and telehealth intervention defined in the loss matrix.

<ins>Monetary Cost Comparison:</ins>

**Current Practice**
* Total cost of readmission: 2,839 × $35,000 = **<ins>$99,365,000</ins>**

**New Model**
* Cost of intervention: (4,565 + 1,055) × $1,200 = $6,744,000
* Cost of readmission: ((1,055 × 0.75) +1,784) × $35,000 = $90,133,750
* Total cost: **<ins>$96,877,750</ins>**

With the anticipated cost of an unplanned readmission $35,000 and a telehealth intervention $1,200, the *Current Practice* generates the total cost of **$99,365,000** for the cost of readmission alone. However, with the *New Model* developed to minimize the total estimated cost through the telehealth intervention:
* The total monetary cost is expected to reduce by $2,487,250, which is equivalent to 2.5% decrease from the initial amount yielded by the *Current Practice*
* The number of 30-days unplanned readmissions is also expected to reduce by 264, equivalent to 9.3% decrease from the *Current Practice*

```bash
#make predictions.
pred.2 = predict(readm.mod.2, newdata=readm.test, type="class")
#view the confusion matrix.
confusion.matrix.2 = table(readm.test$readmission, pred.2)
confusion.matrix.2

# Computation of accuracy, TPR and FPR for both models
accuracy <- sum(diag(confusion.matrix))/sum(confusion.matrix)
accuracy.2 <- sum(diag(confusion.matrix.2))/sum(confusion.matrix.2)

TPR <- confusion.matrix[2,2]/sum(confusion.matrix[2,])
TPR.2 <- confusion.matrix.2[2,2]/sum(confusion.matrix.2[2,])

FPR <- confusion.matrix[1,2]/sum(confusion.matrix[1,])
FPR.20 <- confusion.matrix.2[1,2]/sum(confusion.matrix.2[1,])
![image](https://user-images.githubusercontent.com/55460693/162592003-154a2996-d2b1-4c60-92c3-bc30c19d945a.png)

```


#### 5. Varying the cost telehealth intervention to examine the sensitivity of the benefits

With the variation of the intervention cost by $200, the changes in the number of readmission and total monetary costs are shown as below.

<img width="550" alt="image" src="https://user-images.githubusercontent.com/55460693/162591942-20d69679-bcb4-4ae3-bbe6-12688df7338f.png">

The number of readmissions increases as the cost of intervention increases, because the higher cost of intervention defined in the loss matrix will likely to classify more people in the ‘don’t intervene’ area to minimize the total monetary cost, causing the rise in the number of readmissions.

The total monetary cost also increases as the cost of intervention increases, which is due to the rise of intervention cost itself as well as the increased costs by the rise in the 30-days unplanned readmissions number.
