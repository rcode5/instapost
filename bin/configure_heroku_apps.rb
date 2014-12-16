#!/usr/bin/env ruby
require_relative '../lib/instapost'

domains = %w|callie.rocks ellap.rocks fulton.rocks harperc.rocks jennmeyer.rocks oliverh.rocks ryanc.rocks ryley.rocks waltv.rocks|

if (ARGV.any?)
  desired = ARGV.map{|d| "#{d}.rocks"}
  domains.select!{|d| desired.include? d}
end

domains.each do |domain|

  app = Instapost::AppConfigurator.new(domain)
  print "Configuring #{app.name}..."
  app.configure
  puts "done"

  print "Deploying #{app.name}..."
  app.deploy
  puts "done"

  print "Setting up admin user..."
  app.setup_admin_user
  puts "done"

  print "Setting up other users..."
  app.setup_user email: "jon@bunnymatic.com", password: 'bmatic', name: 'Mr Rogers', login: 'bmatic'
  puts "done"
end
