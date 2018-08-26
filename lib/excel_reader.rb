require 'const'
require 'json'
require 'roo'

class ExcelReader
  AIRPLANE_JSON_FILE = File.join(__dir__, '..', 'data', 'json', 'airplane.json')

  def initialize(excel)
    @excel = excel
  end

  def read_airplane
    ret = Array.new

    excel = Roo::Excelx.new(@excel)
    sheet = excel.sheet('航空機')
    i = 0
    sheet.first_row.upto(sheet.last_row) do |row|
      i += 1
      next if i == 1

      ret.push({
        name: sheet.cell(row, 3),
        plane_type: AIRPLANE_TYPE.index(sheet.cell(row, 4)).nil? ? sheet.cell(row, 4).to_i : AIRPLANE_TYPE.index(sheet.cell(row, 4)),
        up_at_bomb_low_at_fighter: sheet.cell(row, 5).to_i | sheet.cell(row, 6).to_i << 4,
        up_df_bomb_low_df_fighter: sheet.cell(row, 7).to_i | sheet.cell(row, 8).to_i << 4,
        speed: sheet.cell(row, 9).to_i,

        moving_bomb_power: sheet.cell(row, 10).to_i,
        moving_bomb_count: sheet.cell(row, 11).to_i,
        moving_hit_ability: sheet.cell(row, 12).to_i,
        moving_distance: sheet.cell(row, 13).to_i,
        moving_need_fuel: sheet.cell(row, 14).to_i,
        moving_mobility: sheet.cell(row, 15).to_i,
        scout_bomb_power: sheet.cell(row, 16).to_i,
        scout_bomb_count: sheet.cell(row, 17).to_i,
        scout_hit_ability: sheet.cell(row, 18).to_i,
        scout_distance: sheet.cell(row, 19).to_i,
        scout_need_fuel: sheet.cell(row, 20).to_i,
        scout_mobility: sheet.cell(row, 21).to_i,
        normal1_bomb_power: sheet.cell(row, 22).to_i,
        normal1_bomb_count: sheet.cell(row, 23).to_i,
        normal1_hit_ability: sheet.cell(row, 24).to_i,
        normal1_distance: sheet.cell(row, 25).to_i,
        normal1_need_fuel: sheet.cell(row, 26).to_i,
        normal1_mobility: sheet.cell(row, 27).to_i,
        normal2_bomb_power: sheet.cell(row, 28).to_i,
        normal2_bomb_count: sheet.cell(row, 29).to_i,
        normal2_hit_ability: sheet.cell(row, 30).to_i,
        normal2_distance: sheet.cell(row, 31).to_i,
        normal2_need_fuel: sheet.cell(row, 32).to_i,
        normal2_mobility: sheet.cell(row, 33).to_i,
        search_bomb_power: sheet.cell(row, 34).to_i,
        search_bomb_count: sheet.cell(row, 35).to_i,
        search_hit_ability: sheet.cell(row, 36).to_i,
        search_distance: sheet.cell(row, 37).to_i,
        search_need_fuel: sheet.cell(row, 38).to_i,
        search_mobility: sheet.cell(row, 39).to_i,

        work_rate: sheet.cell(row, 40).to_i,
        flag_high_altitude: sheet.cell(row, 41).to_i,

        need_iron: sheet.cell(row, 42).to_i,
        need_arumi: sheet.cell(row, 43).to_i,
        kosu: sheet.cell(row, 44).to_i,
        need_dev_value: sheet.cell(row, 45).to_i,
        need_repair: sheet.cell(row, 46).to_i,
        same_type: sheet.cell(row, 47).to_i,
      })
    end

    excel.close
    ret
  end

  def read_ship
    ret = Array.new

    excel = Roo::Excelx.new(@excel)
    sheet = excel.sheet('艦船')
    i = 0
    sheet.first_row.upto(sheet.last_row) do |row|
      i += 1
      next if i == 1

      ret.push({
        name: sheet.cell(row, 2),
        ship_type: SHIP_TYPE.index(sheet.cell(row, 3)).nil? ? sheet.cell(row, 3).to_i : SHIP_TYPE.index(sheet.cell(row, 3)),
        ship_class: sheet.cell(row, 4).to_i,

        anti_ship: sheet.cell(row, 5).to_i,
        anti_air: sheet.cell(row, 6).to_i,
        torpede_power: sheet.cell(row, 7).to_i,
        endurance_ship: sheet.cell(row, 8).to_i,
        endurance_air: sheet.cell(row, 9).to_i,
        plane_count: sheet.cell(row, 10).to_i,
        gas_amount: sheet.cell(row, 11).to_i,
        plane_repair: sheet.cell(row, 12).to_i,

        max_speed: sheet.cell(row, 13).to_i,
        cruise_speed: sheet.cell(row, 14).to_i,
        max_cruise: sheet.cell(row, 15).to_i,
        fuel: sheet.cell(row, 16).to_i,
        fuel_consumption: sheet.cell(row, 17).to_i,
        size: sheet.cell(row, 18).to_i,
        change_class_avail_flag: (sheet.cell(row, 19).to_i << 4) | sheet.cell(row, 20).to_i,
        after_change_class: sheet.cell(row, 21).to_i,
        change_class_minus_hp: sheet.cell(row, 22).to_i,
        can_build_new_class: sheet.cell(row, 23).to_i,
        mass_product_flag: sheet.cell(row, 24).to_i
      })
    end

    excel.close
    ret
  end

  def read_base
    ret = Array.new

    # JSONデータを取得する。
    airplane_json = File.read(AIRPLANE_JSON_FILE)
    airplane_data = JSON.parse(airplane_json, symbolize_names: true).map { |v| v[:name] }

    excel = Roo::Excelx.new(@excel)
    sheet = excel.sheet('根拠地')
    i = 0
    sheet.first_row.upto(sheet.last_row) do |row|
      i += 1
      next if i == 1

      ajust = sheet.cell(row, 4) == '大日本帝國' ? 0 : 100
      base_plane = 0.step(31, 2).map do |j|
        {
          plane_type: airplane_data.index(sheet.cell(row, 37 + j)).nil? ? sheet.cell(row, 37 + j).to_i : airplane_data.index(sheet.cell(row, 37 + j)) - ajust,
          plane_type_count: sheet.cell(row, 37 + 1 + j).to_i
        }
      end

      ret.push({
        name: sheet.cell(row, 2),

        land_width: sheet.cell(row, 8).to_i,
        air_base_width: sheet.cell(row, 9).to_i,
        port_width: sheet.cell(row, 10).to_i,
        fac_type: FACTORY_TYPE.index(sheet.cell(row, 11)),
        fac_avility: sheet.cell(row, 12).to_i,
        res_type: RESOURCE.index(sheet.cell(row, 13)),
        resource_quantity: sheet.cell(row, 14).to_i,
        fortress: sheet.cell(row, 15).to_i,
        infantry: sheet.cell(row, 16).to_i,
        builder: sheet.cell(row, 17).to_i,
        repair_man: sheet.cell(row, 18).to_i,

        oil: sheet.cell(row, 19).to_i,
        iron_ore: sheet.cell(row, 20).to_i,
        coal: sheet.cell(row, 21).to_i,
        bauxite: sheet.cell(row, 22).to_i,
        food: sheet.cell(row, 23).to_i,
        iron: sheet.cell(row, 24).to_i,
        arumi: sheet.cell(row, 25).to_i,
        bullet: sheet.cell(row, 26).to_i,
        heavy_oil: sheet.cell(row, 27).to_i,
        gas: sheet.cell(row, 28).to_i,

        pilot_fighter_train_1: sheet.cell(row, 29).to_i,
        pilot_fighter_train_2: sheet.cell(row, 30).to_i,
        pilot_fighter_train_3: sheet.cell(row, 31).to_i,
        pilot_fighter_train_4: sheet.cell(row, 32).to_i,
        pilot_bomber_train_1: sheet.cell(row, 33).to_i,
        pilot_bomber_train_2: sheet.cell(row, 34).to_i,
        pilot_bomber_train_3: sheet.cell(row, 35).to_i,
        pilot_bomber_train_4: sheet.cell(row, 36).to_i,

        base_plane: base_plane
      })
    end

    excel.close
    ret
  end
end
