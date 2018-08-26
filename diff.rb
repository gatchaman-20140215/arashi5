require 'json'

buf = JSON.parse(File.read(File.join('data', 'json', 'scenario.json')))
buf2 = JSON.parse(File.read(File.join('data', 'json', 'scenario.json.modified')))

p buf == buf2
