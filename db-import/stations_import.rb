#!/usr/bin/ruby
#encoding: utf-8

require 'uri'
require 'net/http'
require 'parse-ruby-client'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'json'

begin
	Parse.init :application_id => "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu",
            	:api_key        => "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf"

	#station.save

	agent = Mechanize.new
	page = agent.get "http://yadonor.ru/ru/service/where"
	#get list of all regions and links to pages with stations data
	page.search('div.main_block_map_full_list_regions a').each do |link|
  		#puts link.content
  		current_region_name = link.content
  		current_region_link = "http://yadonor.ru"+link['href'].to_s
  		region_page = agent.get current_region_link
  		current_region_id = region_page.search("select[@name=\"id_region\"] option[@selected=\"selected\"]").first["value"].to_s
  		#puts current_region_id
  		region_page.search('.section div.list td').each do |station_html|
  			#doc = Nokogiri::HTML.parse(station_html.to_s)
  			#puts station_html.to_s
  			count = region_page.search('.section div.list td a').count
  			puts count
  			for i in 0..(count-1)
  				begin
  					station = Parse::Object.new "YAStations"
  					next_class = station_html.search('a')[i].next.next["class"].to_s
  					if (next_class=="div_a1")
						station["name"] = station_html.search('a')[i].content.to_s
						other_content = station_html.search('a')[i].next.next.children
						#script_content = station_html.search('a')[i].parent.next.next.children
						#puts "\n"
						district_next = false
						town_next = false

						#script_line = 0
						#begin
						#script_content.to_s.each_line do |item|
						#	if script_line==5
						#		coordinates_string = item.to_s
						#		#puts coordinates_string
						#		method_string = coordinates_string.match(/onclick=".*"/)
						#		method_params = method_string.to_s.scan(/'[^']*'/i)
						#		#puts method_params.inspect
						#		#puts "\n"
						#		station["station_id"] = method_params[0].to_s.gsub("'","").gsub("\\","")
						#		station["lat"] = method_params[1].to_s.gsub("'","").gsub("\\","")
						#		station["lon"] = method_params[2].to_s.gsub("'","").gsub("\\","")
						#		station["latlon"] = JSON.parse("{\"type\": \"GeoPoint\", \"latitude\":"+station["lat"]+", \"longitude\": "+station["lon"]+" }")
						#		#puts station["station_id"].to_s
						#	end
						#	script_line=script_line+1
						#end
						#rescue
						#end


						other_content.each do |item|
							if district_next
								district_next = false
								station["district_name"] = item.content.to_s.strip
								region_page.search("select[@name=\"id_district\"] option").each do |district_item|
									if district_item.content.strip==station["district_name"]
										station["district_id"] = district_item["value"].to_i
									end
								end
							end
							if town_next
								town_next = false
								station["town"] = item.content.to_s.strip
							end

							if (item.to_s.strip.include? "Район:") 
								district_next = true
							end
							if (item.to_s.strip.include? "Город:") 
								town_next = true
							end

							if (item.to_s.strip.include? "Адрес:") 
								station["address"] = item.to_s.strip.gsub("Адрес:","").strip
							end
							if (item.to_s.strip.include? "Телефон:") 
								station["phone"] = item.to_s.strip.gsub("Телефон:","").strip
							end
							if (item.to_s.strip.include? "Время работы:") 
								station["work_time"] = item.to_s.strip.gsub("Время работы:","").strip
							end
							if (item.to_s.strip.include? "Руководитель:") 
								station["chief"] = item.to_s.strip.gsub("Руководитель:","").strip
							end
							if (item.to_s.strip.include? "Email:") 
								station["email"] = item.to_s.strip.gsub("Email:","").strip
							end
							if (item.to_s.strip.include? "Сайт:") 
								station["site"] = item.to_s.strip.gsub("Сайт:","").strip
							end
						end

						begin
							latlon_page = agent.get "http://maps.google.com/maps/api/geocode/xml?address="+station["address"]+"&sensor=false"
							doc_latlon = Nokogiri::XML(latlon_page.content)
							puts doc_latlon.search("status").first.content
							if (doc_latlon.search("status").first.content=="ZERO_RESULTS")
								latlon_page = agent.get "http://maps.google.com/maps/api/geocode/xml?address="+station["town"]+"&sensor=false"
								doc_latlon = Nokogiri::XML(latlon_page.content)

							end
							station["lat"] = doc_latlon.search("location lat").first.content.to_f
							station["lon"] = doc_latlon.search("location lng").first.content.to_f
							station["latlon"] = JSON.parse("{\"type\": \"GeoPoint\", \"latitude\":"+station["lat"].to_s+", \"longitude\": "+station["lon"].to_s+" }")
						rescue=> exception
							#puts exception.inspect
						end

						station["region_name"] = current_region_name
						station["region_id"] = current_region_id.to_i
						puts station["name"]
						puts station.save
					end
				rescue
				end
  			end
  			break
  		end
  		#break
	end
end