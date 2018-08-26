require 'file_reader'
require 'file_writer'
require 'json'
require 'fileutils'

class Submarine
  SUBMARINE_NAME_FILE = File.join(__dir__, '..', 'data', 'dat', 'submd_00.dat')
  SUBMARINE_FILE = File.join(__dir__, '..', 'data', 'dat', 'subm_00.dat')

  SUBMARINE_MODIFY_FILE = File.join(__dir__, '..', 'data', 'modify', 'subm_00.dat')

  MST_COUNT_SUBMARINE = 60

  # 潜水艦データの読み込み
  def read
    submarine_name_buf = read_name

    ret = Array.new

    File.open(SUBMARINE_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_SUBMARINE).each do |i|
        ret.push({
          name: submarine_name_buf[i - 1][:name],
          data: file_reader.read_u_short,
          build_limit_turn: file_reader.read_byte,
          build_limit: file_reader.read_byte,
          gas_amount: file_reader.read_short,
          fuel: file_reader.read_u_int,
          fuel_consumption: file_reader.read_u_short,
          cruise: file_reader.read_u_short,
          size: file_reader.read_short,
          max_speed: file_reader.read_byte,
          cruise_speed: file_reader.read_byte,
          plane_repair: file_reader.read_short,
          mass_product_flag: file_reader.read_byte,
          unknown_22: file_reader.read_byte
        })
      end
    end

    ret
  end

  # 潜水艦名称の読み込み
  def read_name
    ret = Array.new

    File.open(SUBMARINE_NAME_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_SUBMARINE).each do
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

  # 潜水艦データの書き込み
  def write(json_file)
    # 元のデータファイルをコピーする。
    FileUtils.cp(SUBMARINE_FILE, SUBMARINE_MODIFY_FILE, preserve: true)

    # JSONデータを取得する
    submarine_json = File.read(json_file)
    submarine_data = JSON.parse(submarine_json, symbolize_names: true)

    File.open(SUBMARINE_MODIFY_FILE, File::RDWR|File::CREAT) do |file|
      file.binmode

      file_writer = FileWriter.new(file)

      submarine_data.each do |data|
        file_writer.write_u_short(data[:data])
        file_writer.write_byte(data[:build_limit_turn])
        file_writer.write_byte(data[:build_limit])
        file_writer.write_short(data[:gas_amount])
        file_writer.write_u_int(data[:fuel])
        file_writer.write_u_short(data[:fuel_consumption])
        file_writer.write_u_short(data[:cruise])
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
