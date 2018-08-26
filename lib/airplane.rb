require 'file_reader'
require 'file_writer'
require 'json'
require 'fileutils'

class Airplane
  AIRPLANE_NAME_FILE = File.join(__dir__, '..', 'data', 'dat', 'acd_00.dat')
  AIRPLANE_FILE = File.join(__dir__, '..', 'data', 'dat', 'ac_00.dat')

  AIRPLANE_MODIFY_FILE = File.join(__dir__, '..', 'data', 'modify', 'ac_00.dat')

  MST_COUNT_PLANE = 200

  # 航空機データの読み込み
  def read
    ret = Array.new

    File.open(AIRPLANE_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_PLANE).each do |i|
        ret.push({
          id: i - 1,
          plane_type: file_reader.read_byte,

          up_at_bomb_low_at_fighter: file_reader.read_byte,
          up_df_bomb_low_df_fighter: file_reader.read_byte,
          work_rate: file_reader.read_byte,
          flag_high_altitude: file_reader.read_byte,

          unknown_a: file_reader.skip(5),

          name: file_reader.read_string(13),
          speed: file_reader.read_u_short,
          need_iron: file_reader.read_byte,
          need_arumi: file_reader.read_byte,
          kosu: file_reader.read_byte,
          need_dev_value: file_reader.read_u_short,
          need_repair: file_reader.read_byte,
          unknown: file_reader.read_byte,

          unknown_f: file_reader.skip(4),

          same_type: file_reader.read_byte,
          unknown_f2: file_reader.skip(1),

          moving_bomb_power: file_reader.read_u_short,
          moving_bomb_count: file_reader.read_u_short,
          moving_hit_ability: file_reader.read_u_short,
          moving_distance: file_reader.read_u_short,
          moving_need_fuel: file_reader.read_byte,
          moving_mobility: file_reader.read_byte,

          scout_bomb_power: file_reader.read_u_short,
          scout_bomb_count: file_reader.read_u_short,
          scout_hit_ability: file_reader.read_u_short,
          scout_distance: file_reader.read_u_short,
          scout_need_fuel: file_reader.read_byte,
          scout_mobility: file_reader.read_byte,

          normal1_bomb_power: file_reader.read_u_short,
          normal1_bomb_count: file_reader.read_u_short,
          normal1_hit_ability: file_reader.read_u_short,
          normal1_distance: file_reader.read_u_short,
          normal1_need_fuel: file_reader.read_byte,
          normal1_mobility: file_reader.read_byte,

          normal2_bomb_power: file_reader.read_u_short,
          normal2_bomb_count: file_reader.read_u_short,
          normal2_hit_ability: file_reader.read_u_short,
          normal2_distance: file_reader.read_u_short,
          normal2_need_fuel: file_reader.read_byte,
          normal2_mobility: file_reader.read_byte,

          search_bomb_power: file_reader.read_u_short,
          search_bomb_count: file_reader.read_u_short,
          search_hit_ability: file_reader.read_u_short,
          search_distance: file_reader.read_u_short,
          search_need_fuel: file_reader.read_byte,
          search_mobility: file_reader.read_byte,

          corp_no: file_reader.read_byte,

          unknown_g: file_reader.skip(2)
        })
      end
    end

    ret
  end

  # 航空機名称の読み込み
  def read_name
    ret = Array.new

    File.open(AIRPLANE_NAME_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_PLANE).each do
        ret.push({
          name: file_reader.read_string(41),
          pic_no: file_reader.read_u_short,
          engine_power: file_reader.read_u_short,
          rocket_or_jet: file_reader.read_byte,
          pilot_count: file_reader.read_byte,
          length: file_reader.read_u_short,
          width: file_reader.read_u_short,
          weight: file_reader.read_u_int,
          bomb_weight: file_reader.read_u_short,
          gun_main: file_reader.read_u_short,
          gun_sub: file_reader.read_u_short,
          gun_machine: file_reader.read_u_short,
          gun_main_count: file_reader.read_byte,
          gun_sub_count: file_reader.read_byte,
          gun_machine_count: file_reader.read_byte,
          explain: file_reader.read_string(159),
          can_create_year: file_reader.read_u_short,
          can_create_month: file_reader.read_byte,
          can_create_turn: file_reader.read_byte,
          unknown_c: file_reader.skip(3)
        })
      end
    end

    ret
  end

  # 航空機データの書き込み
  def write(json_file, excel_file=nil)
    # 元のデータファイルをコピーする。
    FileUtils.cp(AIRPLANE_FILE, AIRPLANE_MODIFY_FILE, preserve: true)

    # JSONデータを取得する。
    airplane_json = File.read(json_file)
    airplane_data = JSON.parse(airplane_json, symbolize_names: true)

    if excel_file
      require 'excel_reader'
      # Excelデータを取得する。
      modify_data = ExcelReader.new(excel_file).read_airplane

      0.upto(airplane_data.size - 1).each do |i|
        airplane_data[i].merge!(modify_data[i])
      end
    end

    File.open(AIRPLANE_MODIFY_FILE, File::RDWR|File::CREAT) do |file|
      file.binmode

      file_writer = FileWriter.new(file)

      airplane_data.each do |data|
        file_writer.write_byte(data[:plane_type])

        file_writer.write_byte(data[:up_at_bomb_low_at_fighter])
        file_writer.write_byte(data[:up_df_bomb_low_df_fighter])
        file_writer.write_byte(data[:work_rate])
        file_writer.write_byte(data[:flag_high_altitude])

        file_writer.skip(5)

        file_writer.write_string(data[:name], 13)
        file_writer.write_u_short(data[:speed])
        file_writer.write_byte(data[:need_iron])
        file_writer.write_byte(data[:need_arumi])
        file_writer.write_byte(data[:kosu])
        file_writer.write_u_short(data[:need_dev_value])
        file_writer.write_byte(data[:need_repair])
        file_writer.skip(1)

        file_writer.skip(4)

        file_writer.write_byte(data[:same_type])
        file_writer.skip(1)

        file_writer.write_u_short(data[:moving_bomb_power])
        file_writer.write_u_short(data[:moving_bomb_count])
        file_writer.write_u_short(data[:moving_hit_ability])
        file_writer.write_u_short(data[:moving_distance])
        file_writer.write_byte(data[:moving_need_fuel])
        file_writer.write_byte(data[:moving_mobility])

        file_writer.write_u_short(data[:scout_bomb_power])
        file_writer.write_u_short(data[:scout_bomb_count])
        file_writer.write_u_short(data[:scout_hit_ability])
        file_writer.write_u_short(data[:scout_distance])
        file_writer.write_byte(data[:scout_need_fuel])
        file_writer.write_byte(data[:scout_mobility])

        file_writer.write_u_short(data[:normal1_bomb_power])
        file_writer.write_u_short(data[:normal1_bomb_count])
        file_writer.write_u_short(data[:normal1_hit_ability])
        file_writer.write_u_short(data[:normal1_distance])
        file_writer.write_byte(data[:normal1_need_fuel])
        file_writer.write_byte(data[:normal1_mobility])

        file_writer.write_u_short(data[:normal2_bomb_power])
        file_writer.write_u_short(data[:normal2_bomb_count])
        file_writer.write_u_short(data[:normal2_hit_ability])
        file_writer.write_u_short(data[:normal2_distance])
        file_writer.write_byte(data[:normal2_need_fuel])
        file_writer.write_byte(data[:normal2_mobility])

        file_writer.write_u_short(data[:search_bomb_power])
        file_writer.write_u_short(data[:search_bomb_count])
        file_writer.write_u_short(data[:search_hit_ability])
        file_writer.write_u_short(data[:search_distance])
        file_writer.write_byte(data[:search_need_fuel])
        file_writer.write_byte(data[:search_mobility])

        file_writer.write_byte(data[:corp_no])

        file_writer.skip(2)
      end
    end
  end
end
