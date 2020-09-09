require 'csv'

apic = CSV.read('apic7.csv', headers:true)

providers = apic.by_col['organisation']

# move list of unique providers into a hash, sort by count

providers = providers.group_by(&:itself).transform_values(&:count).sort_by {|value, _key| value}.to_h

puts "|Department:|Number of APIs:|Date First Added:|Date Most Recent Added:|Link:|"
puts "|:---|:---|:---|:---|:---|"

providers.each do |itself, count|
 puts "|#{itself}| #{count}||||[https://alphagov.github.io/api-catalogue]([https://alphagov.github.io/api-catalogue)"
end