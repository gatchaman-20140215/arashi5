require 'scenario'

data = Scenario.new.read

0.upto(data[:mst_scenario_ship_war_jp].size - 1) do |i|
  puts "%d:#{data[:mst_scenario_ship_war_jp][i][:name]}" % i
end
