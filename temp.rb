require 'json'

tempHash = {
    "user_id" => 4,
    "name" => "val_b"
}
data_hash = []
file = File.read('data/employee1.json')
data_hash = JSON.parse(file)

puts "debug #{data_hash.last.inspect}"

puts data_hash

data_hash.push(tempHash)

f = File.open("data/employee1.json","w")
f.puts(JSON.pretty_generate(data_hash))
