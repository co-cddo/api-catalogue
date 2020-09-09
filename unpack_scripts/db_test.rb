#!/usr/bin/ruby

require 'sqlite3'
require 'csv'

begin
    
    db = SQLite3::Database.new ":memory:"
   
    db.execute "CREATE TABLE apic(dateadded TEXT, dateupdated TEXT, uuid INTEGER PRIMARY KEY, url TEXT, name TEXT, documentation TEXT, license TEXT, maintainer TEXT, provider TEXT, areaServed TEXT, startDate TEXT, endDate TEXT, organisation TEXT, typeof TEXT)"
    
    CSV.foreach('apic.csv', headers:true).with_index(10) do |row, ln|  #load csv file by row, include headers, add line index for weighting in TDTs, then create  folder and record for each
	
	dateadded = row['dateadded']
	dateupdated = row['dateupdated']
    uuid = row['uuid']
    url = row['url']
    name = row['name']
    documentation = row['documentation']
    license = row['license']
    maintainer = row['maintainer']
    provider = row['provider']
    areaServed = row['areaServed']
    startDate = row['startDate']
    endDate = row['provider']
    organisation = row['organisation']
	typeof = row['endDate']
	
#	fields = File.join("#{dateadded}", "#{dateupdated}", "#{uuid}", "#{url}", "#{name}", "#{documentation}","#{license}", "#{maintainer}", "#{provider}", "#{areaServed}", "#{startDate}", "#{endDate}", "#{organisation}", "#{typeof}")
	
	db.execute("INSERT INTO apic (dateadded, dateupdated, uuid, url, name, documentation, license, maintainer, provider, areaServed, startDate, endDate, organisation, typeof), VALUES (""#{dateadded}", "#{dateupdated}", "#{uuid}", "#{url}", "#{name}", "#{documentation}","#{license}", "#{maintainer}", "#{provider}", "#{areaServed}", "#{startDate}", "#{endDate}", "#{organisation}", "#{typeof}" ")")
    
    id = db.last_insert_row_id
    puts "The last id of the inserted row is #{id}"
        
    end
        
rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end