#!/usr/bin/env ruby
require 'pry'

require_relative '../lib/instapost'

domains = %w|callie.rocks ellap.rocks fulton.rocks harperc.rocks jennmeyer.rocks oliverh.rocks ryanc.rocks ryley.rocks waltv.rocks|

if (ARGV.any?)
  desired = ARGV.map{|d| "#{d}.rocks"}
  domains.select!{|d| desired.include? d}
end

domains.each do |domain|
  app = Instapost::AppConfigurator.new(domain)
  print "Pinging #{app.www_domain}..."
  if app.ping 
    puts "success" 
  else
    puts "failure"
    exit(-1)
  end
end
