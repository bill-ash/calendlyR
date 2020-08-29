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
  testthat::expect_equal(token_resp[[1]], Sys.getenv("GMAIL"))

  # me
  # curl --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/users/me
  test_me <- httr::GET('https://calendly.com/api/v1/users/me',
                       httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )

  me_resp <- jsonlite::fromJSON(httr::content(test_me, 'text'))

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
                          httr::accept_json(),
                          httr::content_type_json(),
                          body = jsonlite::toJSON(
                            list(
                              url = "http://billash-ubuntu.ddns.net:5555/calendly-bill",
                              # an array of events
                              events = list(
                                "invitee.created"
                              ),
                              events = list(
                                "invitee.canceled"
                              )
                            ), auto_unbox = TRUE, pretty = TRUE
                          )
  )

  hook_id <- jsonlite::fromJSON(httr::content(make_hook, 'text'))

  # get subscriptions
  # curl --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/hooks/<hook_id>
  get_subs <- httr::GET(paste0('https://calendly.com/api/v1/hooks/', hook_id$id),
                        httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )

  subs_resp <- jsonlite::fromJSON(httr::content(get_subs, 'text'))

  # get all subscriptions
  # curl --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/hooks
  get_all_subs <- httr::GET('https://calendly.com/api/v1/hooks',
                            httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  )

  subs_all_resp <- jsonlite::fromJSON(httr::content(get_all_subs, 'text'))

  typeof(subs_all_resp$data)
  attributes(subs_all_resp$data)

  # Delete a hook
  # curl  -X DELETE --header "X-TOKEN: <your_token>" https://calendly.com/api/v1/hooks/<hook_id>
  #delete_hook <- httr::DELETE(paste0('https://calendly.com/api/v1/hooks/', hook_id$id),
  #                            httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  #)

  # NULL == 200
  #delete_resp <- httr::content(delete_hook, 'text', encoding = 'UTF-8')


  # Delete all hooks
  #del_hooks <- purrr::map(subs_all_resp$data$id, ~httr::DELETE(paste0('https://calendly.com/api/v1/hooks/', .x),
  #                                                httr::add_headers('X-TOKEN'=Sys.getenv("CALENDLY"))
  #                                                )
  #           )



})



