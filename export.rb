require 'airplane'
require 'ship'
require 'submarine'
require 'base'
require 'scenario'
require 'json'

AIRPLANE_JSON_FILE = File.join('data', 'json', 'airplane.json')
AIRPLANE_NAME_JSON_FILE = File.join('data', 'json', 'airplane_name.json')
SHIP_JSON_FILE = File.join('data', 'json', 'ship.json')
SHIP_NAME_JSON_FILE = File.join('data', 'json', 'ship_name.json')
SUBMARINE_JSON_FILE = File.join('data', 'json', 'submarine.json')
SUBMARINE_NAME_JSON_FILE = File.join('data', 'json', 'submarine_name.json')
BASE_JSON_FILE = File.join('data', 'json', 'base.json')
SCENARIO_JSON_FILE = File.join('data', 'json', 'scenario.json')

# 航空機データをJSON形式で出力する。
File.open(AIRPLANE_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Airplane.new.read))
end

# 航空機名称データをJSON形式で出力する。
File.open(AIRPLANE_NAME_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Airplane.new.read_name))
end

# 艦船データをJSON形式で出力する。
File.open(SHIP_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Ship.new.read))
end

# 艦船名称データをJSON形式で出力する。
File.open(SHIP_NAME_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Ship.new.read_name))
end

# 潜水艦データをJSON形式で出力する。
File.open(SUBMARINE_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Submarine.new.read))
end

# 潜水艦名称データをJSON形式で出力する。
File.open(SUBMARINE_NAME_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Submarine.new.read_name))
end

# 基地データをJSON形式で出力する。
File.open(BASE_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Base.new.read))
end

# シナリオデータをJSON形式で出力する。
File.open(SCENARIO_JSON_FILE, 'wb') do |file|
  file.write(JSON.pretty_generate(Scenario.new.read))
end
