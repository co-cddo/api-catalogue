require 'csv'
require 'FileUtils'

CSV.foreach('catalogue.csv', headers:true).with_index(10) do |row, ln|  #load csv file by row, include headers, add line index for weighting in TDTs, then create  folder and record for each

#create new folder for each API and populate index.html.md.erb
typeof = row['typeof'].to_s
provider = row['provider'].to_s
organisation = row['organisation'].to_s
name = row['name'].gsub(" ","_") #replace spaces with underscores for links
folder_path = File.join("source", "#{typeof}", "#{provider}", "#{name}") #three levels of directories for TDT build
FileUtils.mkdir_p folder_path

File.open "#{folder_path}/index.html.md.erb", 'w' do |file|
  
  file.write "---\n"
  file.write "title: #{row['organisation']}\n"
  file.write "weight: #{ln}\n"
  file.write "---\n"
  file.write"\n\n"
  file.write "# #{row['provider']} #{row['name']}"
  file.write "\n\n"
  
  endpoint = row['url']
  if endpoint
    file.write "**Endpoint URL:**\n"
    file.write " - [#{row['url']}](#{row['url']})"
    file.write "\n\n"
  end
  
  documentation = row['documentation']
  if documentation
    file.write "**Documentation URL:**\n"
    file.write " - [#{row['documentation']}](#{row['documentation']})"
    file.write "\n\n"
  end
  
  contact = row['maintainer']
  if contact
    file.write "**Contact:**\n"
    file.write " - [#{row['maintainer']}](#{row['maintainer']})"
    file.write "\n\n"
  end
    
    file.write "**Description:**\n"
    file.write "#{row['description']}"
    file.write "\n\n"

  license = row['license']
  if license
    file.write "**License:**\n"
    file.write "#{row['license']}"
    file.write "\n\n"
  end
  
  area = row['areaServed']
  if area
    file.write "**Geographic Area:**\n"
    file.write "#{row['Geographic Area']}"
    file.write "\n\n"
  end

  start = row['startDate']
  if start
    file.write "**Start Date:**\n"
    file.write "#{row['startDate']}"
    file.write "\n\n"
  end

  enddate = row['endDate']
  if enddate
    file.write "**End Date:**\n"
    file.write "#{row['endDate']}"
    file.write "\n\n"
  end

  file.close
  end
end