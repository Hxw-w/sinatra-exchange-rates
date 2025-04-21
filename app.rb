require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

exchange_key = ENV.fetch("EXCHANGE_KEY")
currencies_url = "https://api.exchangerate.host/list?access_key=#{exchange_key}"

raw_currencies = HTTP.get(currencies_url).to_s
currencies = JSON.parse(raw_currencies)


get("/") do
  @currency_list = currencies.fetch("currencies").keys
  @currency_list.delete("BOB")
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  @currency_list = currencies.fetch("currencies").keys
  # exclude "BOB" from the list
  @currency_list.delete("BOB")

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @target_currency = params.fetch("to_currency")

  convert_url = "https://api.exchangerate.host/convert?from=#{@original_currency}&to=#{@target_currency}&amount=1&access_key=#{exchange_key}"

  raw_convert = HTTP.get(convert_url).to_s
  convert = JSON.parse(raw_convert)
  @convert_result = convert.fetch("result")

  erb(:to_currency)
end
