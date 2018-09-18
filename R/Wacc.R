#' @title WACC
#' @description Calculate a company's WACC based on cost of Equity and cost of debt. The fraction of debt and equity can be provided by the user.
#'  Otherwise, the function aims to calculate the weights based on most recent balance sheet data collected from the getBalancesheet() function
#' @param Ticker The ticker of the company to evaluated
#' @param cost_Equity The cost of equity as a fraction
#' @param cost_Debt The cost of debt as a fraction
#' @param Tax_Rate The tax rate (%)
#' @param cost_Pref The cost of Preferred stock as a fraction
#' @param Per_Equit Optional, the percentage equity
#' @param Per_Debt Optional, the percentage debt
#' @export
#' @seealso 
#' @return WACC Return the WACC object

WACC <- function(Ticker, cost_Equity, cost_Debt, cost_Pref, Tax_Rate, Per_Equity = 0, Per_Debt = 0) {
  
  # Check if the user provided the percentage Equity
  
  if (Per_Equity != 0 & Per_Debt != 0) {
    
    # The user provided the weights, so the WACC can be calculated
    
    Per_Pref <- 100 - Per_Equity - Per_Debt
    
    WACC <- (Per_Debt/100)*cost_Debt*(1-Tax_Rate/100) + (Per_Equity/100)*(cost_Equity) + (Per_Pref/100)*(cost_Pref)
    
      
  } else {
    
    # The user did not provide the fractions
    
    What_Year <- year(today()) - 1
    
    BS_Data <- GetBalanceSheet(Ticker, year = What_Year)
    
    # Calculate the weights based on the above collected Balance sheet data
    
    # Get common stock equity
    
    Common_Stock <- BS_Data %>% filter(Metric == "Common Stocks, Including Additional Paid in Capital")
    
    # Get preferred stock equity
    
    Preferred_Stock <- BS_Data %>% filter(Metric == "Convertible Preferred Stock, Nonredeemable or Redeemable, Issuer Option, Value")
    
    # Get long_term debt
    
    LT_Debt <- BS_Data %>% filter(Metric == "Long-term Debt, Excluding Current Maturities")
    
    Total <- Common_Stock + Preferred_Stock + LT_Debt
    
    Per_Equity <- Common_Stock/Total
    Per_Pref <- Preferred_Stock/Total
    Per_Debt <- LT_Debt/Total
    
    WACC <- (Per_Debt)*cost_Debt*(1-Tax_Rate/100) + (Per_Equity)*(cost_Equity) + (Per_Pref)*(cost_Pref)
    
  }
  
  # Return the calculated WACC
  
  return(WACC)
  
}