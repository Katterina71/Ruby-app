require 'sinatra'
require 'sinatra/json'
require 'sinatra/cors'
require 'date'

set :bind, '0.0.0.0'
set :port, 4567

set :allow_origin, "http://localhost:3000"
set :allow_methods, "GET,POST,OPTIONS"
set :allow_headers, "content-type,if-modified-since"

invoices = []

get '/invoices' do
  json invoices
end

post '/invoices' do
  content_type :json
  data = JSON.parse(request.body.read)
  start_date = Date.parse(data['start_date'])
  end_date = Date.parse(data['end_date'])
  daily_rate = data['daily_rate'].to_f
  total_days = (end_date - start_date).to_i
  total_amount = total_days * daily_rate

  invoice = {
    id: invoices.size + 1,
    client: data['client'],
    start_date: start_date,
    end_date: end_date,
    daily_rate: daily_rate,
    total_amount: total_amount
  }

  invoices << invoice
  json invoice
end
