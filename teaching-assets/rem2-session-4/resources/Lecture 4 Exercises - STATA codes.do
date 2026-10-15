*** Set work directory
cd "insert your work directory address here"

*** Step 1: Open "Lectures 4-6 Exercises Data.xlsx" in a software of your choice. The file contains the following variables. 
import excel "insert the file location here", sheet("Data") firstrow clear 

*** Step 2: Generate descriptive statistics of all variables. Note the distribution of `Floorarea'. What is the maximum value of this variable? Remove observations with a floor area over 200 squared metres.
sum Price Floorarea Bedrooms Bathrooms Busstation Railstation Airport
tab Transtype 
tab Propertytype
sum Floorarea, detail
drop if Floorarea > 200

*** Step 3: Make natural log transformation of the following variables: Price, Floorarea, Busstation, Railstation and Airport. Save the file to your work directory. 
gen Lprice = log(Price)
gen Lsize = log(Floorarea)
gen Lbus = log(Busstation)
gen Ltrain = log(Railstation)
gen Lairport = log(Airport)

*** Step 4: Convert categorical variables (Propertytype and Date) into numerical ones for regression analysis.
encode Propertytype, gen(type)
recode type (1=4) (2=1) (3=5) (4=3) (5=2)
label define new_property_label 1 "Flat/Apartment" 2 "Terraced House" 3 "Semi-Detached House" 4 "Bungalow" 5 "Detached House"
label values type new_property_label
gen Year = year(Date)

save HPM-Exe, replace

*** Step 5: Estimate a hedonic price model for the rental and the sales market, respectively. Include intercept dummies for property type and transaction year. 
eststo clear
bysort Transtype: eststo: reg Lprice Lsize Lbus Ltrain Lairport Bedrooms Bathrooms i.type i.Year 
bysort Transtype: eststo: reg Price Floorarea Busstation Railstation Airport Bedrooms Bathrooms i.type i.Year 
esttab using HPM-Exe1.rtf, re /// 
	stats(N r2 F p, fmt(%9.0g %10.2f))  b(%10.2f) star(* 0.10 ** 0.05 *** 0.01)  ///
	varwidth(25) modelwidth(7) label onecell nogaps nobaselevels compress ///
	 title(Regression Summary) mtitles("Rental Model - Log" "Sales Model - Log" "Rental Model - Linear" "Sales Model - Linear")

*** Step 6: Estimate a hedonic price model for the rental market only. Include a slope dummy to check if the effect of Floorarea is different between Detached houses and other types of properties. 
eststo clear
eststo: reg Lprice Lsize Lbus Ltrain Lairport Bedrooms Bathrooms i.type i.Year  if Transtype == "Rental"
eststo: reg Lprice Lsize Lbus Ltrain Lairport Bedrooms Bathrooms i.type i.Year c.Lsize#i5.type if Transtype == "Rental"
esttab using HPM-Exe2.rtf, re not /// 
	stats(N r2 F p, fmt(%9.0g %10.2f))  b(%10.2f) star(* 0.10 ** 0.05 *** 0.01)  ///
	varwidth(25) modelwidth(7) label onecell nogaps nobaselevels compress ///
	 title(Regression Summary) mtitles("Intercept dummies only" "Intercept and slope dummies") 
