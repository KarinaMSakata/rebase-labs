require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative 'query_csv'

get '/tests' do
  rows = CSV.read("./data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/exame' do
  File.read('./public/index.html')
end

get '/datas' do
  QueryCsv.new.all
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)