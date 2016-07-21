#app.rb

require 'sinatra'
require 'pry-byebug'
require 'httparty'
require_relative  'helpers'
require_relative '../dice_scraper/script'

get '/index' do
  location = (request.ip.to_s.length < 4) ? Locator.new.location : Locator.new(request.ip).location
  erb :index, locals: {geo_city: "#{location["city"]}", 
  geo_state: "#{location["region_code"]}"}
end

post '/search' do

  scraper = DiceScraper.new(params[:job],params[:location])
  arr = scraper.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")
  scraper.get_all_company_info(arr)
  jobs = scraper.jobs
  erb :results, locals: {jobs: jobs}

end