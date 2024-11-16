
clear
clear
set more off
use "/Users/michaelburrageii/Library/Mobile Documents/com~apple~CloudDocs/Burrage II_OP_PhD/Year2/FA24/Econometrics/Assignments/Assignment 4/dataset_assignment_4.dta", clear

// (a) OLS estimation with all x variables as controls
display "=== (a) OLS Estimation with Standard Errors ==="
regress y x1 x2 x3 x4 x5 // Add other control variables as needed

display "Coefficient of β1 (x1): " _b[x1]
display "Standard error of β1 (x1): " _se[x1]
display "Coefficient of β2 (x2): " _b[x2]
display "Standard error of β2 (x2): " _se[x2]
display "Coefficient of β3 (x3): " _b[x3]
display "Standard error of β3 (x3): " _se[x3]

// (b) OLS estimation with robust standard errors
display "=== (b) OLS Estimation with Robust Standard Errors ==="
regress y x1 x2 x3 x4 x5, robust

display "Coefficient of β1 (x1): " _b[x1]
display "Robust standard error of β1 (x1): " _se[x1]
display "Coefficient of β2 (x2): " _b[x2]
display "Robust standard error of β2 (x2): " _se[x2]
display "Coefficient of β3 (x3): " _b[x3]
display "Robust standard error of β3 (x3): " _se[x3]

// (c) Individual and time fixed effects using reghdfe
display "=== (c) Fixed Effects Estimation with reghdfe ==="

reghdfe y x1 x2 x3 x4 x5, absorb(id t) vce(cluster id)

display "Coefficient of x1: " _b[x1]
display "Robust standard error of x1: " _se[x1]

// (d) Loop through control variable combinations to get closest estimates
display "=== (d) Control Variable Combination Search ==="
local true_beta1 -3
local true_beta2 2
local controls x4 x5 // Add more control variables if needed

foreach c in `controls' {
    regress y x1 x2 x3 `c'
    local beta1 = _b[x1]
    local beta2 = _b[x2]

    if abs(`beta1' - `true_beta1') < 0.1 & abs(`beta2' - `true_beta2') < 0.1 {
        display "Closest estimates found with controls: `c'"
        display "β1: " `beta1' ", β2: " `beta2'
    }
}

// (e) Estimation with a linear time trend
display "=== (e) Estimation with Linear Time Trend ==="
gen t_trend = t
regress y x1 x2 x3 x4 x5 t_trend // Include chosen controls from part (d)

// (f) Estimation with a quadratic time trend
display "=== (f) Estimation with Quadratic Time Trend ==="
gen t_trend2 = t^2
regress y x1 x2 x3 x4 x5 t_trend t_trend2 // Include chosen controls from part (d)
