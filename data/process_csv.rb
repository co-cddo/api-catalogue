require 'csv'
require 'FileUtils'
require 'securerandom'

CSV.open("operational.csv", "wb") do |csv|
csv << ["about", "dateCreated", "dateModified"]
end

CSV.open("catalogue.csv", "wb") do |csv|
csv << ["id", "url", "name", "description", "documentation", "license", "maintainer", "provider", "areaServed", "startDate", "endDate"]
end

#this assumes a temporary csv file - apic.csv - including all records and dates
CSV.foreach('apic.csv', headers:true).with_index(10) do |row|  #load csv file by row, include headers

#generate uuid
uuid = SecureRandom.uuid
#generate date
date = Time.new.strftime("%Y-%m-%d")

#add dateadded, if blank
dateadded = row['dateadded']
if !dateadded
  dateadded = date
end
#add dateupdated, if blank
dateupdated = row['dateupdated']
if !dateupdated
  dateupdated = date
end

CSV.open("operational.csv", "a+") do |csv|
csv << [ "#{uuid}", "#{dateadded}", "#{dateupdated}"]
end

CSV.open("catalogue.csv", "a+") do |csv|
csv << ["#{uuid}", "#{row['url']}", "#{row['name']}", "#{row['description']}", "#{row['documentation']}", "#{row['license']}", "#{row['maintainer']}", "#{row['provider']}", "#{row['areaServed']}", "#{row['startDate']}", "#{row['endDate']}", "#{row['organisation']}"]
end
end