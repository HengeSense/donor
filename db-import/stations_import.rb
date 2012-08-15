# encoding: utf-8
require 'parse-ruby-client'
require 'mysql2'
require 'uri'
require 'json'

HOST ='localhost'
USERNAME ='root'
PASSWORD ='56608366oz'
DATABASE ='donor'


Parse.init :application_id => "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu",:api_key => "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf"
                  
con = Mysql2::Client.new(:host=>HOST, :username=>USERNAME, 
      :password=>PASSWORD, :database=>DATABASE)
 
  station_items = con.query("SELECT n.*, nr.*, a.field_address_value, e.field_email_email, m.field_metro_value, reg.field_attention_value, p.field_phone_value, geo.field_place_openlayers_wkt, web.field_website_url 
  FROM node as n
  LEFT JOIN node_revisions as nr ON (nr.nid=n.nid AND n.vid=nr.vid)
  LEFT JOIN content_field_address as a ON (a.nid=n.nid AND n.vid=a.vid)
  LEFT JOIN content_field_email as e ON (e.nid=n.nid AND n.vid=e.vid)
  LEFT JOIN content_field_metro as m ON (m.nid=n.nid AND n.vid=m.vid)
  LEFT JOIN content_field_phone as p ON (p.nid=n.nid AND n.vid=p.vid) 
  LEFT JOIN content_field_website as web ON (web.nid=n.nid AND n.vid=web.vid)   
  LEFT JOIN content_field_place as geo ON (geo.nid=n.nid AND n.vid=geo.vid)    
  LEFT JOIN content_type_hemotransfusion_station as reg ON (reg.nid=n.nid AND n.vid=reg.vid)
  WHERE n.type='hemotransfusion_station' OR n.type='clinic'");    
   
  station_items.each do |row|     
      station = Parse::Object.new "Stations"
      station["title"]                      = row["title"].to_s
      station["description"]                = row["body"].to_s
      station["adress"]                     = row["field_address_value"].to_s
      station["email"]                      = row["field_email_email"].to_s
      station["transportation"]             = row["field_metro_value"].to_s
      station["regionalRegistrationText"]   = row["field_attention_value"].to_s      
      station["phone"]                      = row["field_phone_value"].to_s
      
      latlonstr = row["field_place_openlayers_wkt"].to_s.gsub("GEOMETRYCOLLECTION(POINT(","").gsub("))","")      
      latlon = latlonstr.split
      
      station["latlon"] = JSON.parse("{\"__type\": \"GeoPoint\", \"latitude\": "+latlon[1]+",       \"longitude\": "+latlon[0]+" }")
      
      station["city"] = 'Москва'
      station["created"]                    = Time.at(row["timestamp"]).iso8601
      station["nid"]                        = row["nid"]

      puts row["nid"].to_s+" "
      station.save
  end

