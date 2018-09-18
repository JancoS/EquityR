---
title: "Readme"
author: "Janco Strydom"
date: "17 September 2018"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# EquityR Package

## Introduction

The main goal of the EquityR package is to provide basic stock/equity analysis. This is done by building on the
packagas tidyquant and finreportr. The aim is to incorporate the package into the tidyquant environment.

The functions are:
  * Plot_Ratios()
  * Growth_Rate()
  * Gordon_growth_rate()
  * Single_DDM()
  * Multi_DDM()
  * Calculate_FCFF()
  * FCFF_Basic()
  * FCFE_Basic()
  * WACC()
  * Justified_PE()
  * Justified_PB()
  * Justified_PS()
  
## Installation
  
The package can be installed as follows:  
  
```{r}
# Devtools github installation

devtools::install_github()

```
  
  
## Basic Example 

In this example, Apple Inc. (AAPL) stock is briefly evaluated. 
  
```{r, echo=FALSE}

Ticker <- "AAPL"

# Plot some of the financial ratios 

Ratios <- c("Earnings Per Share USD", "Dividends USD")

# Call the Plot_Ratios function

Plot_Output <- Plot_Ratios(Ticker, Ratios)

print(Plot_Output[[1]])
print(Plot_Output[[2]])

# Calculate the growth rate g for AAPL. The function calculates the average ROE growth rate and most recent ROE growth rate

growth_rate <- Growth_Rate(Ticker)

# Calculate the growth rate using the Gordon growth model

Gordon_g <- Gordon_Growth(Ticker, Req_Rate = 0.2)

# DDM model
# First using the single stage DDM

Ticker <- "MSFT"
Req <- 0.12
growth_rate <- 0.1

Single_Stage_DDM <- Single_DDM(Ticker, Req, growth_rate)

# Try a multistage DDM

Ticker <- "MSFT"
Req <- 0.12
growth_rate <- 0.11
terminal_g <- 0.08
length <- 5

Multi_Stage_DDM <- Multi_DDM(Ticker, Req, growth_rate, terminal_g, length)

# Calculate the FCFF
# The CalculateFCFF() function calculates the FCFF based on NI, change in WC, CAPEX and depreciation expense

Ticker <- "AAPL"
year <- 2017

FCFF_AAPL_2017 <- Calculate_FCFF(Ticker, year)

# Basic FCFF model

Ticker <- "AAPL"
WACC <- 12
growth_rate <- 0.11

FCFF_Value <- FCFF_Basic(Ticker, WACC, growth_rate)

# Basic FCFE model

Ticker <- "AAPL"
Req <- 0.12
growth_rate <- 0.11
year <- 2017

FCFE_Value <- FCFE_Basic(Ticker,  Req, year, growth_rate)

# Calculate WACC

Ticker <- "AAPL"
Cost_Equity <- 0.12
Cost_Debt <- 0.08
Cost_Pref <- 0.15
Tax_Rate <- 28
Per_Equity <- 0.5
Per_Debt <- 0.3

WACC(Ticker, Cost_Equity, Cost_Debt, Cost_Pref, Tax_Rate, Per_Equity, Per_Debt)

# Calculate 

```

## Vignettes




## Additional

For further reading on the tidyquant package: https://github.com/business-science/tidyquant
For further reading on the finreportr package: https://github.com/sewardlee337/finreportr
  
## Feedback

Please leave any feedback on github.
  
  
  
  

