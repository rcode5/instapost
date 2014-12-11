#!/usr/bin/env ruby

%w|callie.rocks ellap.rocks fulton.rocks harperc.rocks jennmeyer.rocks oliverh.rocks ryanc.rocks ryley.rocks waltv.rocks|.each do |domain|

   parts = domain.split(".")
   app = "instapost-for-#{parts[0]}"
   
   puts "heroku app:create #{app}"
   puts "heroku config:create #{app}"


  
end
