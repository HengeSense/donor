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
 
  review_items = con.query("SELECT n.*, nr.*, r.*
  FROM node as n
  LEFT JOIN node_revisions as nr ON (nr.nid=n.nid AND n.vid=nr.vid)
  LEFT JOIN  content_type_review as r ON (r.nid=n.nid AND n.vid=r.vid)
  WHERE n.type='review'");    
   
  review_items.each do |row|     
      review = Parse::Object.new "StationReviews"
      review["username"] = row["field_nickname_value"].to_s
      review["body"] = row["body"].to_s
      review["station_nid"] = row["field_review_reference_nid"]
      review["vote_schedule"] = (row["field_schedule_rating"].to_i / 20).round.to_i 
      review["vote_registry"] = (row["field_courtesy_rating"].to_i / 20).round.to_i   
      review["vote_physician"] = (row["field_physician_rating"].to_i / 20).round.to_i   
      review["vote_laboratory"] = (row["field_laboratory_rating"].to_i / 20).round.to_i   
      review["vote_buffet"] = (row["field_buffet_rating"].to_i / 20).round.to_i   
      review["vote_organization_donation"] = (row["field_efficiency_rating"].to_i / 20).round.to_i   
      review["vote_room"] = (row["field_comfort_rating"].to_i / 20).round.to_i   
         
      review["vote"] = (row["field_vote_overall_value"].to_i / 20).round.to_i   
          
      review["nid"] = row["nid"]
      review["createdTimestamp"] = row["created"] 
      review["created"] = DateTime.strptime(row["created"].to_s,'%s').to_s

      puts row["nid"].to_s+" "
      review.save
  end

