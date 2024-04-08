require "http"
require "json"

# Hidden variables
pirate_weather_api_key = ENV["PIRATE_WEATHER_KEY"]
gmaps_key = ENV["GMAPS_KEY"]

# Get user location
puts "What is your location?"
loc = gets.chomp

# Assemble the full URL string
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{loc}&key=#{gmaps_key}"

# Place a GET request to the URL and parse response to get lat and lng
raw_response = HTTP.get(gmaps_url)
parsed_response = JSON.parse(raw_response)
lat = parsed_response['results'][0]['geometry']['location']['lat']
lng = parsed_response['results'][0]['geometry']['location']['lng']
puts "Your coordinates are #{lat}, #{lng}"

# Assemble the full URL string 
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{lat},#{lng}"
raw_response = HTTP.get(pirate_weather_url)
parsed_response = JSON.parse(raw_response)

temp = parsed_response['currently']['temperature']
puts "It is currently #{temp}°F"

hourly_data = parsed_response['hourly']['data']
next_hour_summary = hourly_data[0]['summary']
puts "Next hour: #{next_hour_summary}"

if next_hour_summary == "Rain"
  5.times do |hour|
    # pp Time.at(hourly['time']).hour
    puts "In #{hour} hours, there is a #{hourly_data[hour]['precipProbability']} chance of precipitation"
  end
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
