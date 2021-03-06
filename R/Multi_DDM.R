#' @title Multi_DDM
#' @description The function calculates stock value based on a single stage DDM model (Gordon Growth Model)
#' @param Ticker  Provide the stock ticker, which will be searched for on morningstar and yahoo finance
#' @param Req The required rate of return used for discounting
#' @param growth_rate growth_rate now
#' @param terminal_g The terminal growth rate
#' @param length The discounted length from first to terminal dividend, default is 5
#' @export
#' @seealso \code{\link[tidyquant]{tq_get}}
#' @return DDM_Out The results of the DDM model
#' @examples {
#'
#'  Ticker <- "MSFT"
#'  Req <- 0.12
#'  growth_rate <- 0.11
#'  terminal_g <- 0.08
#'  length <- 5
#'  Multi_Stage_DDM <- Multi_DDM(Ticker, Req, growth_rate, terminal_g, length)
#'
#'
#' }

Multi_DDM <- function(Ticker, Req, growth_rate, terminal_g, length = 5) {

  # Get Morningstar data

  MData <- tq_get(Ticker, get = "key.ratios")

  # What do you need for a DDM?
  # 1. The required rate of return
  # 2. The terminal growth rate g
  # 3. The latest dividend

  Divs <- MData %>%
    filter(section == "Financials") %>%
    select(data) %>% unnest() %>%
    filter(category == "Dividends USD")

  Div_latest <- Divs %>%
    filter(row_number() == nrow(Divs)) %>% pull(value)

  # 4. The ROE

  ROE <- MData %>%
    filter(section == "Profitability") %>%
    select(data) %>% unnest() %>%
    filter(category == "Return on Equity %")

  ROE_latest <- ROE %>%
    filter(row_number() == nrow(ROE))


  # 5. Calculate dividends and discount

  # Create a growth (g) vector and create CFs from dividends

  CFs <- as_tibble(seq(from = growth_rate, to = terminal_g, length.out = length)) %>%
    rename(Growth = value) %>%
    mutate(Growth = Growth + 1) %>%
    mutate(DIV = Div_latest*(1+growth_rate))

  Div_ <- CFs %>% filter(row_number() == 1) %>% pull(DIV)

  for (i in 2:nrow(CFs)) {

    CFs <- CFs %>%
      mutate(DIV = if_else(row_number() == i, Growth*Div_, DIV))

    Div_ <- CFs %>% filter(row_number() == i) %>% pull(DIV)
  }

  # Discount dividends

  RR <- Req + 1

  CFs <- CFs %>%
    mutate(period = row_number()) %>%
    mutate(DF = RR^(period)) %>%
    mutate(CF = DIV/DF) %>%
    mutate(CF = if_else(row_number() == length, CF/(Req - terminal_g), CF))

  # Return the sum of CFs

  DDM_out <- sum(CFs %>% pull(CF))

  return(DDM_out)

}
