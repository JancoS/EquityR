#' @title Growth_Rate
#' @description This function aims to calculate the terminal growth rate g using the retention ratio b and return on equity (ROE). It calculates the growth rate using the most recent data or average data and returns both.
#' @param Ticker The ticker of the stock to be evaluated
#' @export
#' @seealso \code{\link[tidyquant]{tq_get}}
#' @return Growth The estimated average and recent growth rate. Returns a list.
#' @examples \dontrun {
#'  # Calculate the growth rate g for AAPL. The function calculates the average ROE growth rate and most recent ROE growth rate
#'    growth_rate <- Growth_Rate("AAPL")
#' }

Growth_Rate <- function(Ticker) {

  # Get the ticker data

  MData <- as_tibble(tq_get(Ticker, get = "key.ratios"))

  # The first method in calculating the growth rate = b*ROE, where b is the retention ratio

  ROEdata <- MData %>%
    filter(section == "Profitability") %>%
    dplyr::select(data) %>%
    unnest() %>%
    filter(category == "Return on Equity %") %>%
    dplyr::select(date, value) %>%
    na.omit(value) %>%
    rename(ROE = value)

  Retrat <- MData %>%
    filter(section == "Financials") %>%
    dplyr::select(data) %>%
    unnest() %>%
    filter(category == "Payout Ratio % *") %>%
    dplyr::select(date, value) %>%
    na.omit(value) %>%
    mutate(b = 1 - value/100)

  # First calculate g based on most recent ROE and b

  Date_ <- ROEdata %>%
    filter(row_number() == nrow(ROEdata)) %>% pull(date)

  b_latest <- Retrat %>%
    filter(date == Date_) %>% pull(b)

  ROE_latest <- ROEdata %>%
    filter(date == Date_) %>% pull(ROE)


  g_latest <- b_latest*ROE_latest


  # Calculate g based on an average

  Combined <- ROEdata %>%
    left_join(., Retrat, by = c("date")) %>%
    mutate(g = b*ROE/100)

  g_average <- mean(Combined %>% pull(g), na.rm = T)


  Growth <- list("Average" = g_average, "Now" = g_latest/100)

  return(Growth)

}





