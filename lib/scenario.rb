require 'file_reader'
require 'file_writer'
require 'json'
require 'fileutils'

class Scenario
  SCENARIO_FILE = File.join(__dir__, '..', 'data', 'dat', 'scenario', 'sc01.bin')

  SCENARIO_MODIFY_FILE = File.join(__dir__, '..', 'data', 'modify', 'sc01.bin')

  # シナリオデータの読み込み
  def read
    File.open(SCENARIO_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      {
        title: file_reader.read_string(32),
        start_turn: file_reader.read_u_short,
        start_fase: file_reader.read_byte,
        year: file_reader.read_byte,
        month: file_reader.read_byte,
        day: file_reader.read_byte,

        unknown_b1: file_reader.read_byte,
        end_turn: file_reader.read_short,

        win_capture_normal_base: file_reader.read_short,
        unknown_b2: file_reader.skip(4),
        has_normal_base: file_reader.read_u_short,

        map_limit: file_reader.read_byte,
        unknown_b2b: file_reader.skip(2),
        lose_was_captured_important_base: file_reader.read_u_short,
        capital: file_reader.read_u_short,

        win_capture_create_base: file_reader.read_u_short,
        unknown_b4: file_reader.skip(10),

        scenario_exp: file_reader.read_string(512),

        unknown_c: file_reader.skip(1400),
        file_name_dip: file_reader.read_string(26),
        dip_exp_1: file_reader.read_string(301),
        dip_exp_2: file_reader.read_string(301),
        dip_exp_3: file_reader.read_string(301),

        file_name_plane: file_reader.read_string(25),
        file_name_ship: file_reader.read_string(25),
        file_name_sub: file_reader.read_string(25),
        file_name_plane_name: file_reader.read_string(25),
        file_name_ship_name: file_reader.read_string(25),
        file_name_sub_name: file_reader.read_string(25),
        file_name_base: file_reader.read_string(25),

        unknown_d: file_reader.skip(12),

        # 艦船データの読み込み
        mst_scenario_ship_war_jp: read_scenario_ship(file_reader, 950),
        mst_scenario_ship_cargo_jp: read_scenario_ship(file_reader, 250),
        mst_scenario_ship_war_us: read_scenario_ship(file_reader, 950),
        mst_scenario_ship_cargo_us: read_scenario_ship(file_reader, 250),

        # 艦隊データの読み込み
        mst_scenario_fleet_ship_jp: read_scenario_fleet_ship(file_reader, 30),
        mst_scenario_fleet_ship_us: read_scenario_fleet_ship(file_reader, 30),

        # 潜水艦隊データの読み込み
        mst_scenario_fleet_sub_jp: read_scenario_fleet_sub(file_reader, 15),
        mst_scenario_fleet_sub_us: read_scenario_fleet_sub(file_reader, 15),

        # 造船ライン
        mst_scenario_line_ship:
          1.upto(20).map do
            {
              base_id: file_reader.read_byte,
              line_ship_id:
                1.upto(8).map { file_reader.read_u_short },
              line_ship_progress:
                1.upto(8).map { file_reader.read_u_short },
              line_ship_create_type:
                1.upto(8).map { file_reader.read_byte },
              new_ship: file_reader.read_byte
            }
          end,

        # 技術レベル
        mst_tech_level:
          1.upto(2).map do
            {
              magnetic_torpede: file_reader.read_u_short,
              vt: file_reader.read_u_short,
              rader: file_reader.read_u_short,
              oil: file_reader.read_u_short,
              schnorchel: file_reader.read_u_short,
              soner: file_reader.read_u_short,
              atomic: file_reader.read_u_short
            }
          end,
        mst_tech_level_add:
          1.upto(2).map do
            1.upto(7).map do
              file_reader.read_byte
            end
          end,

        # 航空機開発
        scenario_tech_plane: read_scenario_tech_air(file_reader, 76),

        unknown_f: file_reader.skip(331),

        # 航空機ライン
        scenario_fac_plane:
          1.upto(9).map do
            read_scenario_line_plane(file_reader)
          end
      }
    end
  end

  # シナリオデータの書き込み
  def write(json_file)
    # 元のデータファイルをコピーする。
    FileUtils.cp(SCENARIO_FILE, SCENARIO_MODIFY_FILE, preserve: true)

    # JSONデータを取得する
    scenario_json = File.read(json_file)
    scenario_data = JSON.parse(scenario_json, symbolize_names: true)

    File.open(SCENARIO_MODIFY_FILE, File::RDWR|File::CREAT) do |file|
      file.binmode

      file_writer = FileWriter.new(file)

      data = scenario_data
      file_writer.write_string(data[:title], 32)
      file_writer.write_u_short(data[:start_turn])
      file_writer.write_byte(data[:start_fase])
      file_writer.write_byte(data[:year])
      file_writer.write_byte(data[:month])
      file_writer.write_byte(data[:day])

      file_writer.skip(1)
      file_writer.write_short(data[:end_turn])

      file_writer.write_short(data[:win_capture_normal_base])
      file_writer.skip(4)
      file_writer.write_u_short(data[:has_normal_base])

      file_writer.write_byte(data[:map_limit])
      file_writer.skip(2)
      file_writer.write_u_short(data[:lose_was_captured_important_base])
      file_writer.write_u_short(data[:capital])

      file_writer.write_u_short(data[:win_capture_create_base])
      file_writer.skip(10)

      file_writer.write_string(data[:scenario_exp], 512)

      file_writer.skip(1400)
      file_writer.write_string(data[:file_name_dip], 26)
      file_writer.write_string(data[:dip_exp_1], 301)
      file_writer.write_string(data[:dip_exp_2], 301)
      file_writer.write_string(data[:dip_exp_3], 301)

      file_writer.write_string(data[:file_name_plane], 25)
      file_writer.write_string(data[:file_name_ship], 25)
      file_writer.write_string(data[:file_name_sub], 25)
      file_writer.write_string(data[:file_name_plane_name], 25)
      file_writer.write_string(data[:file_name_ship_name], 25)
      file_writer.write_string(data[:file_name_sub_name], 25)
      file_writer.write_string(data[:file_name_base], 25)

      file_writer.skip(12)

      # 艦船データの書き込み
      write_scenario_ship(file_writer, data[:mst_scenario_ship_war_jp])
      write_scenario_ship(file_writer, data[:mst_scenario_ship_cargo_jp])
      write_scenario_ship(file_writer, data[:mst_scenario_ship_war_us])
      write_scenario_ship(file_writer, data[:mst_scenario_ship_cargo_us])

      # 艦隊データの書き込み
      write_scenario_fleet_ship(file_writer, data[:mst_scenario_fleet_ship_jp])
      write_scenario_fleet_ship(file_writer, data[:mst_scenario_fleet_ship_us])

      # 潜水艦データの書き込み
      write_scenario_fleet_sub(file_writer, data[:mst_scenario_fleet_sub_jp])
      write_scenario_fleet_sub(file_writer, data[:mst_scenario_fleet_sub_us])

      # 造船ライン
      data[:mst_scenario_line_ship].each do |v|
        file_writer.write_byte(v[:base_id])
        v[:line_ship_id].each { |w| file_writer.write_u_short(w) }
        v[:line_ship_progress].each { |w| file_writer.write_u_short(w) }
        v[:line_ship_create_type].each { |w| file_writer.write_byte(w) }
        file_writer.write_byte(v[:new_ship])
      end

      # 技術レベル
      data[:mst_tech_level].each do |v|
        file_writer.write_u_short(v[:magnetic_torpede])
        file_writer.write_u_short(v[:vt])
        file_writer.write_u_short(v[:rader])
        file_writer.write_u_short(v[:oil])
        file_writer.write_u_short(v[:schnorchel])
        file_writer.write_u_short(v[:soner])
        file_writer.write_u_short(v[:atomic])
      end
      data[:mst_tech_level_add].each do |v|
        v.each do |w|
          file_writer.write_byte(w)
        end
      end

      # 航空機開発
      data[:scenario_tech_plane].each do |v|
        file_writer.write_string(v[:name], 21)
        file_writer.write_byte(v[:id])
        file_writer.write_u_short(v[:need_dev_value])
        file_writer.write_u_short(v[:dev_value])
        file_writer.write_byte(v[:fix_value])
        v[:next_dev].each do |w|
          file_writer.write_byte(w)
        end
        file_writer.write_byte(v[:corporation])
        file_writer.skip(3)
      end

      file_writer.skip(331)

      # 航空機ライン
      data[:scenario_fac_plane].each do |v|
        v.each do |w|
          file_writer.write_string(w[:name], 21)
          file_writer.write_byte(w[:plane_id])
          file_writer.write_u_short(w[:create_plan])
          file_writer.write_u_short(w[:create_available_count])
          file_writer.write_byte(w[:change_plane_id])
          file_writer.write_byte(w[:change_turn])
          file_writer.skip(3)
          file_writer.write_u_short(w[:kousu])
          file_writer.skip(2)
        end
        file_writer.skip(362)
      end
    end
  end

  def ship_data
    buf = read_mst_scenario
    i = -1
    buf[:mst_scenario_ship_war_jp].map do |v|
      {
        id: i += 1,
        name: v[:name]
      }
    end
  end

  private
  def read_scenario_ship(file_reader, number)
    1.upto(number).map do
      {
        ship_type: file_reader.read_byte,
        state: file_reader.read_byte,
        belong_to: file_reader.read_byte,

        ship_id: file_reader.read_byte,
        hp: file_reader.read_u_short,

        gas: file_reader.read_u_short,
        formation: file_reader.read_byte,

        name: file_reader.read_string(21),
        cruise: file_reader.read_u_short,

        fuel: file_reader.read_u_int,
        mst_scenario_plane_on_ship:
          1.upto(16).map do
            {
              plane_type: file_reader.read_byte,
              plane_count: file_reader.read_u_short,
              repair_par_100: file_reader.read_u_short,
              repair_par_81: file_reader.read_u_short,
              repair_par_62: file_reader.read_u_short,
              repair_par_50: file_reader.read_u_short,
              repair_par_37: file_reader.read_u_short,
              repair_par_25: file_reader.read_u_short,
            }
          end,
        carring_size: file_reader.read_u_short,

        unknown_d: file_reader.skip(46)
      }
    end
  end

  def read_scenario_fleet_ship(file_reader, number)
    1.upto(number).map do
      {
        unknown_a1: file_reader.read_byte,
        order: file_reader.read_byte,
        unknown_a3: file_reader.read_byte,
        unknown_a4: file_reader.read_byte,
        unknown_b: file_reader.read_u_short,

        unknown_c: file_reader.skip(45),

        x: file_reader.read_u_short,
        y: file_reader.read_u_short,
        base: file_reader.read_byte,
        underway: file_reader.read_byte,
        name: file_reader.read_string(21),
        unknown: file_reader.read_byte,
        minimam_cruise: file_reader.read_u_short,
        fuel_all_ship: file_reader.read_u_int,

        dst_x: file_reader.read_u_short,
        dst_y: file_reader.read_u_short,

        unknown_e: file_reader.skip(301)
      }
    end
  end

  def read_scenario_fleet_sub(file_reader, number)
    1.upto(number).map do
      {
        unknown_a1: file_reader.read_byte,
        unknown_a2: file_reader.read_byte,
        unknown_a3: file_reader.read_byte,

        x: file_reader.read_u_short,
        y: file_reader.read_u_short,
        base: file_reader.read_byte,
        underway: file_reader.read_byte,
        name: file_reader.read_string(28),

        dst_x: file_reader.read_u_short,
        dst_y: file_reader.read_u_short,

        unknown_e: file_reader.skip(45)
      }
    end
  end

  def read_scenario_tech_air(file_reader, number)
    1.upto(number).map do
      {
        name: file_reader.read_string(21),
        id: file_reader.read_byte,
        need_dev_value: file_reader.read_u_short,
        dev_value: file_reader.read_u_short,
        fix_value: file_reader.read_byte,
        next_dev:
          1.upto(6).map do
            file_reader.read_byte
          end,
        corporation: file_reader.read_byte,
        unknown: file_reader.skip(3)
      }
    end
  end

  def read_scenario_line_plane(file_reader)
    buf = 1.upto(23).map do
      {
        name: file_reader.read_string(21),
        plane_id: file_reader.read_byte,
        create_plan: file_reader.read_u_short,
        create_available_count: file_reader.read_u_short,
        change_plane_id: file_reader.read_byte,
        change_turn: file_reader.read_byte,
        unknown_a: file_reader.skip(3),
        kousu: file_reader.read_u_short,
        unknown_b: file_reader.skip(2),
      }
    end

    file_reader.skip(362)

    buf
  end

  def write_scenario_ship(file_writer, data)
    data.each do |v|
      file_writer.write_byte(v[:ship_type])
      file_writer.write_byte(v[:state])
      file_writer.write_byte(v[:belong_to])

      file_writer.write_byte(v[:ship_id])
      file_writer.write_u_short(v[:hp])

      file_writer.write_u_short(v[:gas])
      file_writer.write_byte(v[:formation])

      file_writer.write_string(v[:name], 21)
      file_writer.write_u_short(v[:cruise])

      file_writer.write_u_int(v[:fuel])

      v[:mst_scenario_plane_on_ship].each do |w|
        file_writer.write_byte(w[:plane_type])
        file_writer.write_u_short(w[:plane_count])
        file_writer.write_u_short(w[:repair_par_100])
        file_writer.write_u_short(w[:repair_par_81])
        file_writer.write_u_short(w[:repair_par_62])
        file_writer.write_u_short(w[:repair_par_50])
        file_writer.write_u_short(w[:repair_par_37])
        file_writer.write_u_short(w[:repair_par_25])
      end

      file_writer.write_u_short(v[:carring_size])

      file_writer.skip(46)
    end
  end

  def write_scenario_fleet_ship(file_writer, data)
    data.each do |v|
      file_writer.skip(1)
      file_writer.write_byte(v[:order])
      file_writer.skip(4)

      file_writer.skip(45)

      file_writer.write_u_short(v[:x])
      file_writer.write_u_short(v[:y])
      file_writer.write_byte(v[:base])
      file_writer.write_byte(v[:underway])
      file_writer.write_string(v[:name], 21)
      file_writer.skip(1)
      file_writer.write_u_short(v[:minimam_cruise])
      file_writer.write_u_int(v[:fuel_all_ship])

      file_writer.write_u_short(v[:dst_x])
      file_writer.write_u_short(v[:dst_y])

      file_writer.skip(301)
    end
  end

  def write_scenario_fleet_sub(file_writer, data)
    data.each do |v|
      file_writer.skip(3)

      file_writer.write_u_short(v[:x])
      file_writer.write_u_short(v[:y])
      file_writer.write_byte(v[:base])
      file_writer.write_byte(v[:underway])
      file_writer.write_string(v[:name], 28)

      file_writer.write_u_short(v[:dst_x])
      file_writer.write_u_short(v[:dst_y])

      file_writer.skip(45)
    end
  end
end
