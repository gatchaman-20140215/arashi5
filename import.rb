require 'airplane'
require 'ship'
require 'submarine'
require 'base'
require 'scenario'
require 'json'
require 'tempfile'

AIRPLANE_JSON_FILE = File.join(__dir__, 'data', 'json', 'airplane.json')
SHIP_JSON_FILE = File.join(__dir__, 'data', 'json', 'ship.json')
SUBMARINE_JSON_FILE = File.join(__dir__, 'data', 'json', 'submarine.json')
BASE_JSON_FILE = File.join(__dir__, 'data', 'json', 'base.json')
SCENARIO_JSON_FILE = File.join(__dir__, 'data', 'json', 'scenario.json')

excel = File.join(__dir__, 'data', 'excel', '太平洋の嵐5.xlsx')
Airplane.new.write(AIRPLANE_JSON_FILE, excel)
Ship.new.write(SHIP_JSON_FILE, excel)
Submarine.new.write(SUBMARINE_JSON_FILE)
Base.new.write(BASE_JSON_FILE, excel)

modify_file = File.join(__dir__, 'data', 'modify_scenario.json')
if File.exists?(modify_file)
  buf = JSON.parse(File.read(SCENARIO_JSON_FILE), symbolize_names: true)

  modify_buf = JSON.parse(File.read(modify_file), symbolize_names: true)
  0.upto(modify_buf[:mst_scenario_ship_war_jp].size - 1).each do |i|
    buf[:mst_scenario_ship_war_jp][644 + i] = modify_buf[:mst_scenario_ship_war_jp][i]
  end
  buf[:mst_scenario_line_ship] = modify_buf[:mst_scenario_line_ship]
  buf[:mst_scenario_fleet_ship_jp] = modify_buf[:mst_scenario_fleet_ship_jp]
  buf[:mst_scenario_fleet_sub_jp] = modify_buf[:mst_scenario_fleet_sub_jp]
  buf[:scenario_tech_plane] = modify_buf[:scenario_tech_plane]  

  Tempfile.open('modified_scenario.json') do |file|
    file.write(JSON.pretty_generate(buf))
    Scenario.new.write(file.path)
  end
else
  Scenario.new.write(SCENARIO_JSON_FILE)
end
