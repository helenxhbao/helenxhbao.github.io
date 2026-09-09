*** Import data
import excel "Lectures 4-6 Exercises data.xlsx", sheet("Lecture 6") firstrow clear

*** Set time variable
gen qdate = yq(year(quarter), quarter(quarter))
format qdate %tq
tsset qdate

*** Time series charts
foreach var in "SPSC_price" "SPSC_return" "REIT_price" "REIT_return" "SP500_price" "SP500_return" {
twoway (line `var' quarter), title("`var'") xlabel(, labsize(2)) name(g`var', replace) nodraw	
	}

graph combine gSPSC_price gREIT_price gSP500_price  gSPSC_return  gREIT_return gSP500_return, col(3)

twoway (line REIT_price qdate, yaxis(1)) (line Anxious_index qdate, yaxis(2)) (line CPI qdate, yaxis(2)) , ///
       title("Price, Anxious Index, and CPI") ///
       legend(order(1 "REIT Price" 2 "Anxious Index" 3 "CPI" )) ///
       xlabel(, format(%tq)) ///
       yscale(range(200 600) axis(1)) ///
       yscale(range(0 200) axis(2)) ///
       ylabel(0(100)500, axis(1)) ///
       ylabel(0(40)200, axis(2)) ///
       ytitle("REIT Price", axis(1)) ///
       ytitle("Anxious Index / CPI", axis(2))

*** Stationarity test (The null hypothesis is the series has a unit root, i.e., non-stationary)
dfuller REIT_return
dfuller SPSC_return
dfuller SP500_return
dfuller REIT_price
dfuller SPSC_price
dfuller SP500_price
dfuller Anxious_index 
dfuller CPI 
dfuller Real_GDP

*** LS with stationary variables
reg REIT_return Anxious_index Real_GDP

*** Determine the optimal lag length
varsoc REIT_price Anxious_index CPI Real_GDP, maxlag(4)

*** Cointegration test
*** trace statistic: The null hypothesis is that the number of cointegrating equations is less than or equal to r
*** maximum eigenvalue statistic: The null hypothesis is that the number of cointegrating equations is equal to r
vecrank REIT_price Anxious_index CPI Real_GDP, lag(1)
vecrank REIT_price Anxious_index CPI Real_GDP, lag(2)

*** AR model
reg REIT_return l.REIT_return Anxious_index Real_GDP

*** VAR model
var REIT_price Anxious_index CPI Real_GDP, lag(1)

*** ECM model
regress REIT_price Anxious_index CPI Real_GDP
predict ecm_residual, resid
regress D.REIT_price D.Anxious_index D.CPI D.Real_GDP L.ecm_residual

*** VEC model
vec REIT_price Anxious_index CPI Real_GDP, lag(2) rank(1)
