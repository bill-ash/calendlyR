# first try to gen from an open api spec

skip('OpenAPIspec')

# devtools::install_github("ropenscilabs/apipkgen")
# library(rapiclient)
# inst/node.raw
cal_api <- get_api('https://calendly.stoplight.io/api/nodes.raw?srn=gh/calendly/api-docs/reference/calendly-api/openapi.yaml')
operations <- get_operations(cal_api)
# no schema :(
schemas <- get_schemas(cal_api)

operations$getUser()


cal_api <- get_api('https://calendly.stoplight.io/api/nodes.raw?srn=gh/calendly/api-docs/reference/calendly-api/openapi.yaml&deref=bundle')
operations <- get_operations(cal_api)
# no schema :(
schemas <- get_schemas(cal_api)

operations$getUser(uuid = )
