# Albany-hub-analytics
Code repository for Georgia Tech-ESRI Albany Hub Analytics and Visualization Project.  
This Python script runs protocols for Policy and Program Evaluation of HUD funded properties and electric utilities city use from 2004 to 2019. This code has been packaged to run as a standalone script. 

# Methodology for computation
Participating properties are compared to a statistical reference group of non-participating properties using propensity score matching. A set of matching covariates is used to mitigate self-selection bias. Regression adjustment that includes time and location fixed effects are also considered. The unit of analysis for housing units is at the property level. 

## Matching_PanelOLS.ipynb
The code here processes data on treated and untreated units, such as individual houses, and performs propensity score matching on covariates known to influence a unit's conditional probability of being in the treated group. After matching and verifying adequate bias reduction, a fixed effects regression is performed to determine the average treatment effect (ATE) for the treated units compared to the matched control units. 

### Matching
The Python code in this section takes covoariates, such as house size in square footage, normalized electricity consumption (by square footage), property value, etc., and uses them to predict the propensity a house that did not receive HUD funding would be statistically similar to a house that did receive HUD funding.

### Fixed Effects Panel Regression
The Python code in this section evaluates the policy effects of HUD funding on the normalized electric utility consumption from 2004 to 2019. Standard errors are clustered to both the individual unit and time unit levels.

### Note
Two files are needed to utilize this code. The first file is a cross-sectional file that contains information and covariates on the units of analysis before the treatment period. This file is used for the propensity score matching. The second file needed is a panel file that contains the variables and covariates of interest in the pre- and post-treatment period for the units of analysis. After matching, the appropriate treated and matched controls are selected from the panel set for analysis.
