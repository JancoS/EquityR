#' @title FCFF_Basic
#' @description Basic valuation of a company using the free cash flow to firm. Value = (FCFF(1+g))/(WACC - g)
#' @param Ticker The ticker of the stock to be evaluated
#' @param WACC The WACC as a percentage
#' @param growth_rate The growth rate g
#' @export
#' @return FCFF_Value


FCFF_Basic <- function(Ticker, WACC, growth_rate) {

  # Get data from Morningstar

  MData <- tq_get(Ticker, get = "key.ratios")

  # Get WACC from user

  WACC <- WACC/100

  # Get FCFF

  FCFF <- MData %>%
    filter(section == "Financials") %>%
    select(data) %>% unnest() %>%
    filter(category == "Free Cash Flow USD Mil")

  FCFF_latest <- FCFF %>%
    filter(row_number() == nrow(FCFF)) %>% pull(value)

  # Calculate value

  FCFF_Value <- (FCFF_latest*(1 + growth_rate))/(WACC - growth_rate)

  return(FCFF_Value)

}
