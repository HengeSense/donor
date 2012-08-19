# encoding: utf-8
require 'parse-ruby-client'
require 'mysql2'
require 'uri'

HOST ='localhost'
USERNAME ='root'
PASSWORD ='56608366oz'
DATABASE ='donor'


Parse.init :application_id => "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu",:api_key => "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf"
                  
con = Mysql2::Client.new(:host=>HOST, :username=>USERNAME, 
      :password=>PASSWORD, :database=>DATABASE)
 
  news_items = con.query("SELECT n.*, nr.* FROM node as n
  LEFT JOIN node_revisions as nr ON (nr.nid=n.nid AND n.vid=nr.vid)
  WHERE n.type='news'");    
   
  news_items.each do |row|     
      news = Parse::Object.new "News"
      news["title"]         = row["title"].to_s
      news["body"]          = row["body"].to_s
     
      news["createdTimestamp"] = row["created"]
 
      news["created"] = DateTime.strptime(row["created"].to_s,'%s').to_s
      #puts DateTime.strptime(row["created"].to_s,'%s').to_s
      #puts row["created"].to_s
      news["nid"]           = row["nid"]
      puts row["nid"].to_s+" "
      news.save
  end

