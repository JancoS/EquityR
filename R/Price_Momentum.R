#' @title Price_Momentum
#' @description Get price momentum for given time periods
#' @param Times List of time periods in months
#' @param Ticker Stock ticker to be evaluated
#' @export
#' @seealso \code{\link[tidyquant]{tq_get}}
#' @return Mom Momentum output
#' @examples \dontrun {
#'
#' }

Price_Momentum <- function(Ticker, Times) {

  # Max price momentum is 36 months, so only collect data for this period

  Tod <- lubridate::today() - lubridate::days(1)
  Begin <- Tod - lubridate::years(3)

  Prices <- as_tibble(tq_get(Ticker, get = "stock.prices", from = Begin) %>% dplyr::select(date, close))

  Price_Today <- Prices %>% filter(date == Tod) %>% pull(close)

  # Calculate the momentum for each given time period

  for (i in 1:length(Times)) {

    # Where to start looking

    Wher <- Tod - months(as.numeric(Times[i]))

    # Calculate momentum

    Wher_P <- Prices %>% filter(date == Wher) %>% pull(close)

    if (is_empty(Wher_P)) {

      Wher <- Wher - days(2)
      Wher_P <- Prices %>% filter(date == Wher) %>% pull(close)

    }else {

      Wher <- Wher

    }

    Mom <- as_tibble((Price_Today/Wher_P) - 1) %>% rename(Mom = value) %>% mutate(Time = Times[i])

    if (i == 1) {

      Final_Mom <- Mom

    } else {

      Final_Mom <- Final_Mom %>% bind_rows(., Mom)

    }

    remove(Mom)

  }

  return(Final_Mom)

}

