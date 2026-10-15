*** Set work directory
cd "insert your work directory address here"

*** Step 1: Open "Lectures 4-6 Exercises Data.xlsx" in a software of your choice. Estimate the following regression model by using the rental market data only.
import excel "insert the file location here", sheet("Data") firstrow clear 
gen Lprice = log(Price)
gen Lsize = log(Floorarea)
gen Lbus = log(Busstation)
gen Ltrain = log(Railstation)
gen Lairport = log(Airport)
drop if Floorarea > 200 | Transtype != "Rental"

reg Lprice Lsize Lbus Ltrain Lairport Bedrooms Bathrooms i.type i.Year  

*** Step 2: Generate the predicted values and residuals from the regression model.
capture drop pre_values residuals
predict pre_values, xb
predict residuals, resid

*** Step 3: Generate scatter plots between the residual series and the predicted values. Does the pattern appear to be random? 
twoway scatter residuals pre_values, ///
    yline(0, lcolor(red) lpattern(dash)) ///
    title("Residuals vs. Predicted Values") ///
    ytitle("Residuals") xtitle("Predicted Values")

*** Step 4: Generate a histogram of the residuals. Does it seem to be normally distributed? Generate a Q-Q plot to double check the results.
histogram residuals, normal title("Histogram of Residuals")
qnorm residuals

*** Step 5: Perform a RESET test to check if any higher order terms or interaction terms of the independent variables are missing from the regression model.
ovtest

*** Step 6: Request VIF statistics to check the level of multicollinearity. Is there any concern?
vif

*** Step 7: Perform a White test to check the homoskedasticity assumption. Request the Robust Standard Errors if the model does not pass the test. 
estat imtest, white
reg Lprice Lsize Lbus Ltrain Lairport Bedrooms Bathrooms i.type i.Year, robust
