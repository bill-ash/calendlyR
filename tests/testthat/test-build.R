library(httr)
library(tidyverse)
library(jsonlite)
#curl -v --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/echo


testthat::test_that('Test some basic functions using `httr`', {

  # Organize  your thoughts

  # test token
  test_token <- GET('https://calendly.com/api/v1/echo',
           httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY")))

  token_resp <- fromJSON(content(test_token, 'text'))

  testthat::expect_length(token_resp, 1)
  testthat::expect_equal(token_resp[[1]], 'ash.william.r@gmail.com')


})
