require 'file_reader'
require 'file_writer'
require 'json'
require 'fileutils'

class Ship
  SHIP_NAME_FILE = File.join(__dir__, '..', 'data', 'dat', 'shipd_00.dat')
  SHIP_FILE = File.join(__dir__, '..', 'data', 'dat', 'ship00.dat')

  SHIP_MODIFY_FILE = File.join(__dir__, '..', 'data', 'modify', 'ship00.dat')

  MST_COUNT_SHIP = 180

  # 艦船データの読み込み
  def read
    ship_name_buf = read_name

    ret = Array.new

    File.open(SHIP_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_SHIP).each do |i|
        ret.push({
          name: ship_name_buf[i - 1][:name],
          type: file_reader.read_byte,
          change_class_avail_flag: file_reader.read_byte,
          anti_ship: file_reader.read_byte,
          endurance_ship: file_reader.read_byte,
          anti_air: file_reader.read_byte,
          endurance_air: file_reader.read_byte,
          torpede_power: file_reader.read_byte,
          plane_count: file_reader.read_byte,
          after_change_class: file_reader.read_byte,
          change_class_minus_hp: file_reader.read_byte,
          can_build_new_class: file_reader.read_u_short,
          ship_class: file_reader.read_byte,
          unknown_5: file_reader.read_byte,
          gas_amount: file_reader.read_short,
          fuel: file_reader.read_u_int,
          fuel_consumption: file_reader.read_short,
          max_cruise: file_reader.read_u_short,
          size: file_reader.read_short,
          max_speed: file_reader.read_byte,
          cruise_speed: file_reader.read_byte,
          plane_repair: file_reader.read_short,
          mass_product_flag: file_reader.read_byte,
          unknown_13: file_reader.read_byte
        })
      end
    end

    ret
  end

  # 艦船名称の読み込み
  def read_name
    ret = Array.new

    File.open(SHIP_NAME_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_SHIP).each do
        ret.push({
          name: file_reader.read_string(25),
          pic_no: file_reader.read_short,
          weight: file_reader.read_int,
          length: file_reader.read_short,
          gun_main: file_reader.read_short,
          gun_sub: file_reader.read_short,
          anti_air: file_reader.read_short,
          gun_machine: file_reader.read_short,
          torpedo: file_reader.read_short,
          gun_main_count: file_reader.read_byte,
          gun_sub_count: file_reader.read_byte,
          anti_air_count: file_reader.read_byte,
          gun_machine_count: file_reader.read_byte,
          torpedo_count: file_reader.read_byte,
          same_type_count: file_reader.read_byte,
          country: file_reader.read_byte,
          explain: file_reader.read_string(157)
        })
      end
    end

    ret
  end

  # 艦船データの書き込み
  def write(json_file, excel_file=nil)
    # 元のデータファイルをコピーする。
    FileUtils.cp(SHIP_FILE, SHIP_MODIFY_FILE, preserve: true)

    # JSONデータを取得する
    ship_json = File.read(json_file)
    ship_data = JSON.parse(ship_json, symbolize_names: true)

    if excel_file
      require 'excel_reader'
      # Excelデータを取得する。
      modify_data = ExcelReader.new(excel_file).read_ship

      0.upto(ship_data.size - 1).each do |i|
        ship_data[i].merge!(modify_data[i])
      end
    end

    File.open(SHIP_MODIFY_FILE, File::RDWR|File::CREAT) do |file|
      file.binmode

      file_writer = FileWriter.new(file)

      ship_data.each do |data|
        file_writer.write_byte(data[:type])
        file_writer.write_byte(data[:change_class_avail_flag])
        file_writer.write_byte(data[:anti_ship])
        file_writer.write_byte(data[:endurance_ship])
        file_writer.write_byte(data[:anti_air])
        file_writer.write_byte(data[:endurance_air])
        file_writer.write_byte(data[:torpede_power])
        file_writer.write_byte(data[:plane_count])
        file_writer.write_byte(data[:after_change_class])
        file_writer.write_byte(data[:change_class_minus_hp])
        file_writer.write_u_short(data[:can_build_new_class])
        file_writer.write_byte(data[:ship_class])
        file_writer.skip(1)
        file_writer.write_short(data[:gas_amount])
        file_writer.write_u_int(data[:fuel])
        file_writer.write_short(data[:fuel_consumption])
        file_writer.write_u_short(data[:max_cruise])
        file_writer.write_short(data[:size])
        file_writer.write_byte(data[:max_speed])
        file_writer.write_byte(data[:cruise_speed])
        file_writer.write_short(data[:plane_repair])
        file_writer.write_byte(data[:mass_product_flag])
        file_writer.skip(1)
      end
    end
  end
end
