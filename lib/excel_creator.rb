require 'airplane'
require 'ship'
require 'submarine'
require 'base'
require 'const'
require 'axlsx'

class ExcelCreator
  def initialize(excel)
    @excel = excel
  end

  def create
    excel = Axlsx::Package.new
    sheet = excel.workbook.add_worksheet(name: '航空機')
    create_airplane_sheet(sheet)

    sheet = excel.workbook.add_worksheet(name: '艦船')
    create_ship_sheet(sheet)

    sheet = excel.workbook.add_worksheet(name: '潜水艦')
    create_submarine_sheet(sheet)

    sheet = excel.workbook.add_worksheet(name: '根拠地')
    create_base_sheet(sheet)

    excel.serialize(@excel)
  end

  private
  # 航空機シートを作成する。
  AIRPLANE_TITLE = %w(
    id 名前 略名 種別
    対戦闘機攻撃力 対爆撃機攻撃力 対戦闘機防御力 対爆撃機防御力 速度
    移動時爆撃力 移動時爆弾数 移動時命中力 移動時距離 移動時必要燃料 移動時機動力
    偵察時爆撃力 偵察時爆弾数 偵察時命中力 偵察時距離 偵察時必要燃料 偵察時機動力
    通常1時爆撃力 通常1時爆弾数 通常1時命中力 通常1時距離 通常1時必要燃料 通常1時機動力
    通常2時爆撃力 通常2時爆弾数 通常2時命中力 通常2時距離 通常2時必要燃料 通常2時機動力
    索敵時時爆撃力 索敵時時爆弾数 索敵時時命中力 索敵時時距離 索敵時時必要燃料 索敵時時機動力
    稼働率 高高度
    必要鉄 必要軽銀 必要生産力 必要開発力 必要整備力 同一形式 製造会社
    画像No エンジン出力 R/J 搭乗員数 全長 幅 重量 爆弾搭載重量
    機銃1 機銃2 機銃3 機銃1数 機銃2数 機銃3数
    出現年数 出現月 出現ターン 備考
  )

  def create_airplane_sheet(sheet)
    airplane_data = Airplane.new.read
    airplane_name_data = Airplane.new.read_name

    sheet.add_row(AIRPLANE_TITLE)

    0.upto(airplane_data.size - 1) do |i|
      if i < 100
        corp = MAKER_JP[airplane_data[i][:corp_no]].nil? ? airplane_data[i][:corp_no] : MAKER_JP[airplane_data[i][:corp_no]]
      else
        corp = MAKER_US[airplane_data[i][:corp_no]].nil? ? airplane_data[i][:corp_no] : MAKER_US[airplane_data[i][:corp_no]]
      end

      sheet.add_row(
        [
          i,
          airplane_name_data[i][:name],
          airplane_data[i][:name],
          AIRPLANE_TYPE[airplane_data[i][:plane_type]].nil? ? airplane_data[i][:plane_type] : AIRPLANE_TYPE[airplane_data[i][:plane_type]],

          airplane_data[i][:up_at_bomb_low_at_fighter] & 0b00001111,
          (airplane_data[i][:up_at_bomb_low_at_fighter] & 0b11110000) >> 4,
          airplane_data[i][:up_df_bomb_low_df_fighter] & 0b00001111,
          (airplane_data[i][:up_df_bomb_low_df_fighter] & 0b11110000) >> 4,
          airplane_data[i][:speed],

          airplane_data[i][:moving_bomb_power],
          airplane_data[i][:moving_bomb_count],
          airplane_data[i][:moving_hit_ability],
          airplane_data[i][:moving_distance],
          airplane_data[i][:moving_need_fuel],
          airplane_data[i][:moving_mobility],
          airplane_data[i][:scout_bomb_power],
          airplane_data[i][:scout_bomb_count],
          airplane_data[i][:scout_hit_ability],
          airplane_data[i][:scout_distance],
          airplane_data[i][:scout_need_fuel],
          airplane_data[i][:scout_mobility],
          airplane_data[i][:normal1_bomb_power],
          airplane_data[i][:normal1_bomb_count],
          airplane_data[i][:normal1_hit_ability],
          airplane_data[i][:normal1_distance],
          airplane_data[i][:normal1_need_fuel],
          airplane_data[i][:normal1_mobility],
          airplane_data[i][:normal2_bomb_power],
          airplane_data[i][:normal2_bomb_count],
          airplane_data[i][:normal2_hit_ability],
          airplane_data[i][:normal2_distance],
          airplane_data[i][:normal2_need_fuel],
          airplane_data[i][:normal2_mobility],
          airplane_data[i][:search_bomb_power],
          airplane_data[i][:search_bomb_count],
          airplane_data[i][:search_hit_ability],
          airplane_data[i][:search_distance],
          airplane_data[i][:search_need_fuel],
          airplane_data[i][:search_mobility],

          airplane_data[i][:work_rate],
          airplane_data[i][:flag_high_altitude],

          airplane_data[i][:need_iron],
          airplane_data[i][:need_arumi],
          airplane_data[i][:kosu],
          airplane_data[i][:need_dev_value],
          airplane_data[i][:need_repair],
          airplane_data[i][:same_type],
          corp,

          airplane_name_data[i][:pic_no],
          airplane_name_data[i][:engine_power],
          airplane_name_data[i][:rocket_or_jet],
          airplane_name_data[i][:pilot_count],
          airplane_name_data[i][:length],
          airplane_name_data[i][:width],
          airplane_name_data[i][:weight],
          airplane_name_data[i][:bomb_weight],
          airplane_name_data[i][:gun_main],
          airplane_name_data[i][:gun_sub],
          airplane_name_data[i][:gun_machine],
          airplane_name_data[i][:gun_main_count],
          airplane_name_data[i][:gun_sub_count],
          airplane_name_data[i][:gun_machine_count],
          airplane_name_data[i][:can_create_year],
          airplane_name_data[i][:can_create_month],
          airplane_name_data[i][:can_create_turn],
          airplane_name_data[i][:explain],
        ]
      )
    end
  end

  # 艦船シートを作成する。
  SHIP_TITLE = %w(
    id 名前 タイプ クラス
    対艦攻撃力 対空攻撃力 雷撃力 対艦防御力 対空防御力 搭載機数 ガソリン 整備力
    最大速度 巡航速度 航続距離 燃料 燃費 規模 対潜 改装可能 改装後タイプ 改装後マイナス規模 新造艦出現ターン数 量産可能
    重量 全長 主砲 副砲 高角砲 機銃 魚雷 主砲数 副砲数 高角砲数 機銃数 魚雷数 画像番号 同型艦数 国籍
  )

  def create_ship_sheet(sheet)
    ship_data = Ship.new.read
    ship_name_data = Ship.new.read_name

    sheet.add_row(SHIP_TITLE)

    0.upto(ship_data.size - 1) do |i|
      sheet.add_row(
        [
          i,
          ship_data[i][:name],
          SHIP_TYPE[ship_data[i][:type]].nil? ? ship_data[i][:type] : SHIP_TYPE[ship_data[i][:type]],
          ship_data[i][:ship_class],

          ship_data[i][:anti_ship],
          ship_data[i][:anti_air],
          ship_data[i][:torpede_power],
          ship_data[i][:endurance_ship],
          ship_data[i][:endurance_air],
          ship_data[i][:plane_count],
          ship_data[i][:gas_amount],
          ship_data[i][:plane_repair],

          ship_data[i][:max_speed],
          ship_data[i][:cruise_speed],
          ship_data[i][:max_cruise],
          ship_data[i][:fuel],
          ship_data[i][:fuel_consumption],
          ship_data[i][:size],
          ship_data[i][:change_class_avail_flag] >> 4,
          ship_data[i][:change_class_avail_flag] & 0x0F,
          ship_data[i][:after_change_class],
          ship_data[i][:change_class_minus_hp],
          ship_data[i][:can_build_new_class],
          ship_data[i][:mass_product_flag],

          ship_name_data[i][:weight],
          ship_name_data[i][:length],
          ship_name_data[i][:gun_main] / 100.0,
          ship_name_data[i][:gun_sub] / 100.0,
          ship_name_data[i][:anti_air] / 100.0,
          ship_name_data[i][:gun_machine] / 100.0,
          ship_name_data[i][:torpedo] / 100.0,
          ship_name_data[i][:gun_main_count],
          ship_name_data[i][:gun_sub_count],
          ship_name_data[i][:anti_air_count],
          ship_name_data[i][:gun_machine_count],
          ship_name_data[i][:torpedo_count],
          ship_name_data[i][:pic_no],
          ship_name_data[i][:same_type_count],
          COUNTRY_SHIP[ship_name_data[i][:country]],
          ship_name_data[i][:explain],
         ]
      )
    end
  end

  # 潜水艦シートを作成する。
  SUBMARINE_TITLE = %w(
    id 艦型 艦影番号 雷撃力 搭載機数 ガソリン 燃料 燃費 航続距離 規模 最大速度 巡航速度 整備力 量産 建艦制限ターン数 建艦制限
    重量 全長 主砲 副砲 高角砲 機銃 魚雷 主砲数 副砲数 高角砲数 機銃数 魚雷数 同型関数 国籍
  )

  def create_submarine_sheet(sheet)
    submarine_data = Submarine.new.read
    submarine_name_data = Submarine.new.read_name

    sheet.add_row(SUBMARINE_TITLE)

    0.upto(submarine_data.size - 1) do |i|
      sheet.add_row(
        [
          i,
          submarine_data[i][:name],
          submarine_name_data[i][:pic_no],
          submarine_data[i][:data] >> 2 & 0x7F,
          submarine_data[i][:data] >> 13 & 0x07,
          submarine_data[i][:gas_amount],
          submarine_data[i][:fuel],
          submarine_data[i][:fuel_consumption],
          submarine_data[i][:cruise],
          submarine_data[i][:size],
          submarine_data[i][:max_speed],
          submarine_data[i][:cruise_speed],
          submarine_data[i][:plane_repair],
          submarine_data[i][:mass_product_flag],
          submarine_data[i][:build_limit_turn],
          submarine_data[i][:build_limit],

          submarine_name_data[i][:weight],
          submarine_name_data[i][:length],
          submarine_name_data[i][:gun_main] / 100.0,
          submarine_name_data[i][:gun_sub] / 100.0,
          submarine_name_data[i][:anti_air] / 100.0,
          submarine_name_data[i][:gun_machine] / 100.0,
          submarine_name_data[i][:torpedo] / 100.0,
          submarine_name_data[i][:gun_main_count],
          submarine_name_data[i][:gun_sub_count],
          submarine_name_data[i][:anti_air_count],
          submarine_name_data[i][:gun_machine_count],
          submarine_name_data[i][:torpedo_count],
          submarine_name_data[i][:same_type_count],
          COUNTRY_SHIP[submarine_name_data[i][:country]],
          submarine_name_data[i][:explain],
         ]
      )
    end
  end

  # 基地シートを作成する。
  BASE_TITLE = %w(
    id 根拠地名 カナ 国 根拠地種別 座標X 座標Y 平地 飛行場 泊地
    工場種別 最大工場能力 資源種別 資源産出量 防御施設 戦闘部隊 設営部隊 修理部隊
    原油 鉄鉱石 石炭 鉄礬土 食糧 鉄 軽銀 弾薬 重油 ガソリン
    戦闘機搭乗員練度1 戦闘機搭乗員練度2 戦闘機搭乗員練度3 戦闘機搭乗員練度4
    爆撃機搭乗員練度1 爆撃機搭乗員練度2 爆撃機搭乗員練度3 爆撃機搭乗員練度4
  )

  def create_base_sheet(sheet)
    base_data = Base.new.read
    airplane_data = Airplane.new.read

    sheet.add_row(BASE_TITLE)

    0.upto(base_data.size - 1) do |i|
      if base_data[i][:country] == 0
        airplane = base_data[i][:base_plane].map do |v|
          [
            airplane_data[v[:plane_type]].nil? ? v[:plane_type] : airplane_data[v[:plane_type]][:name],
            v[:plane_type_count]
          ]
        end.flatten
      else
        airplane = base_data[i][:base_plane].map do |v|
          [
            airplane_data[v[:plane_type] + 100].nil? ? v[:plane_type] : airplane_data[v[:plane_type] + 100][:name],
            v[:plane_type_count]
          ]
        end.flatten
      end

      sheet.add_row(
        [
          i,
          base_data[i][:name],
          base_data[i][:kana],
          COUNTRY_BASE[base_data[i][:country]],
          BASE_TYPE[base_data[i][:base_type]],
          base_data[i][:x],
          base_data[i][:y],
          base_data[i][:land_width],
          base_data[i][:air_base_width],
          base_data[i][:port_width],
          FACTORY_TYPE[base_data[i][:fac_type]].nil? ? base_data[i][:fac_type] : FACTORY_TYPE[base_data[i][:fac_type]],
          base_data[i][:fac_avility],
          RESOURCE[base_data[i][:res_type]],
          base_data[i][:resource_quantity],
          base_data[i][:fortress],
          base_data[i][:infantry],
          base_data[i][:builder],
          base_data[i][:repair_man],

          base_data[i][:oil],
          base_data[i][:iron_ore],
          base_data[i][:coal],
          base_data[i][:bauxite],
          base_data[i][:food],
          base_data[i][:iron],
          base_data[i][:arumi],
          base_data[i][:bullet],
          base_data[i][:heavy_oil],
          base_data[i][:gas],

          base_data[i][:pilot_fighter_train_1],
          base_data[i][:pilot_fighter_train_2],
          base_data[i][:pilot_fighter_train_3],
          base_data[i][:pilot_fighter_train_4],
          base_data[i][:pilot_bomber_train_1],
          base_data[i][:pilot_bomber_train_2],
          base_data[i][:pilot_bomber_train_3],
          base_data[i][:pilot_bomber_train_4],
         ] + airplane
      )
    end
  end
end

