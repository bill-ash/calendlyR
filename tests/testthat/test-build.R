library(httr)
library(jsonlite)
#To subscribe to webhooks, you need to have a paid Premium or Pro Calendly account. All other API access mirrors the access level you have in the Calendly web app.


testthat::test_that('Test some basic functions using `httr`', {

  # Organize  your thoughts

  # test token
  # curl -v --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/echo
  test_token <- httr::GET('https://calendly.com/api/v1/echo',
                          httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )

  token_resp <- jsonlite::fromJSON(httr::content(test_token, 'text'))

  testthat::expect_length(token_resp, 1)
  testthat::expect_equal(token_resp[[1]], 'ash.william.r@gmail.com')

  # me
  # curl --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/users/me
  test_me <- httr::GET('https://calendly.com/api/v1/users/me',
                       httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )

  me_resp <- jsonlite::fromJSON(httr::content(test_me, 'text'))

  attributes(me_resp)
  typeof(me_resp)

  str(me_resp)

  testthat::expect_length(me_resp[[1]], 3)
  testthat::expect_equal(me_resp[[1]]$attributes$email, 'ash.william.r@gmail.com')
  testthat::expect_equal(me_resp[[1]]$attributes$slug, 'bill-ash')


  # Event types
  # curl --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/users/me/event_types
  test_events <- httr::GET('https://calendly.com/api/v1/users/me/event_types',
                           httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )
  # These are my events but where are my meetings?
  events_resp <- jsonlite::fromJSON(httr::content(test_events, 'text'))
  tibble::as_tibble(events_resp[[1]])

  # test webhooks
  # curl \
  # --header "X-TOKEN: <your_token>" \
  # --data "url=https://blah.foo/bar" \
  # --data "events[]=invitee.created" \
  # https://calendly.com/api/v1/hooks
  # Using mockbin


  # this doesn't work - can make webhooks over http with plumber
  make_hook <- httr::POST("https://calendly.com/api/v1/hooks",
                          httr::add_headers('X-TOKEN' = Sys.getenv("CALENDLY")),
                          body = jsonlite::toJSON(
                            list(
                              url = "https://hookb.in/K3aXloV9JPc0zzW3VogK",
                              # an array of events
                              events = list(
                                "invitee.created"
                              )
                            ), auto_unbox = TRUE, pretty = TRUE
                          )
  )

  httr::content(make_hook, 'text')


})



