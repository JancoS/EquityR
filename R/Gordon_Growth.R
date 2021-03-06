#' @title Gordon_Growth
#' @description The function calculates the growth rate based on the Gordon Growth model: g = r - D1/P
#' @param Ticker Stock to be evaluated
#' @param Req_Rate Required rate of return for specific stock
#' @export
#' @seealso \code{\link[tidyquant]{tq_get}}
#' @return Gordon_g The growth rate output
#' @examples {
#'
#'  Gordon_Growth("AAPL", Req_Rate = 0.2)
#'
#' }

Gordon_Growth <- function(Ticker, Req_Rate) {

  # Get data from Morningstar

  MDATA <- as_tibble(tq_get(Ticker, get = "key.ratios"))

  # Get Latest price
  Today <- lubridate::today()
  Price <- tq_get(Ticker, get = "stock.prices", from = Today, to = Today) %>% pull(close)

  # Get dividend

  MDATA <- MDATA %>%  filter(section == "Financials") %>%
    dplyr::select(data) %>%
    unnest() %>%
    filter(sub.section == "Financials" & category == "Dividends USD")

  Div <- MDATA %>% filter(row_number() == nrow(MDATA)) %>% pull(value)

  Gordon_g <- (-Div + Req_Rate*Price)/(Div + Price)

  return(Gordon_g)
}
