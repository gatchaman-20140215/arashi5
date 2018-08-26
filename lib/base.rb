require 'file_reader'
require 'file_writer'
require 'json'
require 'pp'
require 'fileutils'

class Base
  BASE_FILE = File.join(__dir__, '..', 'data', 'dat', 'scenario', 'base01.bin')

  BASE_MODIFY_FILE = File.join(__dir__, '..', 'data', 'modify', 'base01.bin')

  MST_COUNT_BASE = 204

  # 基地データの読み込み
  def read
    ret = Array.new

    File.open(BASE_FILE, 'rb') do |file|
      file_reader = FileReader.new(file)

      1.upto(MST_COUNT_BASE).each do
        ret.push({
          base_type: file_reader.read_byte,
          country: file_reader.read_byte,
          land_width: file_reader.read_short,
          air_base_width: file_reader.read_short,
          fac_type: file_reader.read_byte,
          res_type: file_reader.read_byte,
          jap_or_alliance: file_reader.read_byte,
          unknown_8: file_reader.read_byte,
          unknown_9: file_reader.read_byte,
          x: file_reader.read_short,
          y: file_reader.read_short,
          name: file_reader.read_string(21),
          port_width: file_reader.read_u_short,
          unknown_14: file_reader.read_byte,
          unknown_15: file_reader.read_byte,
          fac_avility: file_reader.read_short,
          resource_quantity: file_reader.read_int,
          fortress: file_reader.read_byte,
          infantry: file_reader.read_byte,

          builder: file_reader.read_byte,
          repair_man: file_reader.read_byte,

          base_plane:
            1.upto(16).map do
              {
                plane_type: file_reader.read_byte,
                plane_type_count: file_reader.read_short,
                unknown: file_reader.skip(12)
              }
            end,

          unknown_a: file_reader.skip(8),

          oil: file_reader.read_u_int,
          iron_ore: file_reader.read_u_int,
          coal: file_reader.read_u_int,
          bauxite: file_reader.read_u_int,
          food: file_reader.read_u_int,
          iron: file_reader.read_u_int,
          arumi: file_reader.read_u_int,
          bullet: file_reader.read_u_int,
          heavy_oil: file_reader.read_u_int,
          gas: file_reader.read_u_int,

          pilot_fighter_train_1: file_reader.read_u_int,
          pilot_fighter_train_2: file_reader.read_u_int,
          pilot_fighter_train_3: file_reader.read_u_int,
          pilot_fighter_train_4: file_reader.read_u_int,
          pilot_bomber_train_1: file_reader.read_u_int,
          pilot_bomber_train_2: file_reader.read_u_int,
          pilot_bomber_train_3: file_reader.read_u_int,
          pilot_bomber_train_4: file_reader.read_u_int,

          connect_1: file_reader.read_byte,
          connect_2: file_reader.read_byte,
          connect_3: file_reader.read_byte,
          connect_4: file_reader.read_byte,
          connect_5: file_reader.read_byte,
          read_level_1: file_reader.read_byte,
          read_level_2: file_reader.read_byte,
          read_level_3: file_reader.read_byte,
          read_level_4: file_reader.read_byte,
          read_level_5: file_reader.read_byte,

          scout:
            1.upto(12).map do
              {
                unknown_a: file_reader.read_u_short,
                distance: file_reader.read_u_short,
                unknown_b: file_reader.read_u_short,
                unknown: file_reader.skip(4)
              }
            end,

          create_avility: file_reader.read_u_short,
          fixed_num: file_reader.read_byte,
          unknown_d: file_reader.skip(6),

          kana: file_reader.read_string(21)
        })
      end
    end

    ret
  end


  # 基地データの書き込み
  def write(json_file, excel_file=nil)
    # 元のデータファイルをコピーする。
    FileUtils.cp(BASE_FILE, BASE_MODIFY_FILE, preserve: true)

    # JSONデータを取得する
    base_json = File.read(json_file)
    base_data = JSON.parse(base_json, symbolize_names: true)

    if excel_file
      require 'excel_reader'
      # Excelデータを取得する。
      modify_data = ExcelReader.new(excel_file).read_base

      0.upto(base_data.size - 1).each do |i|
        base_data[i].merge!(modify_data[i])
      end
    end

    File.open(BASE_MODIFY_FILE, File::RDWR|File::CREAT) do |file|
      file.binmode

      file_writer = FileWriter.new(file)

      base_data.each do |data|
        file_writer.write_byte(data[:base_type])
        file_writer.write_byte(data[:country])
        file_writer.write_short(data[:land_width])
        file_writer.write_short(data[:air_base_width])
        file_writer.write_byte(data[:fac_type])
        file_writer.write_byte(data[:res_type])
        file_writer.write_byte(data[:jap_or_alliance])
        file_writer.skip(2)
        file_writer.write_short(data[:x])
        file_writer.write_short(data[:y])
        file_writer.write_string(data[:name], 21)
        file_writer.write_u_short(data[:port_width])
        file_writer.skip(2)
        file_writer.write_short(data[:fac_avility])
        file_writer.write_int(data[:resource_quantity])
        file_writer.write_byte(data[:fortress])
        file_writer.write_byte(data[:infantry])

        file_writer.write_byte(data[:builder])
        file_writer.write_byte(data[:repair_man])

        data[:base_plane].each do |v|
          file_writer.write_byte(v[:plane_type])
          file_writer.write_short(v[:plane_type_count])
          file_writer.skip(12)
        end

        file_writer.skip(8)

        file_writer.write_u_int(data[:oil])
        file_writer.write_u_int(data[:iron_ore])
        file_writer.write_u_int(data[:coal])
        file_writer.write_u_int(data[:bauxite])
        file_writer.write_u_int(data[:food])
        file_writer.write_u_int(data[:iron])
        file_writer.write_u_int(data[:arumi])
        file_writer.write_u_int(data[:bullet])
        file_writer.write_u_int(data[:heavy_oil])
        file_writer.write_u_int(data[:gas])

        file_writer.write_u_int(data[:pilot_fighter_train_1])
        file_writer.write_u_int(data[:pilot_fighter_train_2])
        file_writer.write_u_int(data[:pilot_fighter_train_3])
        file_writer.write_u_int(data[:pilot_fighter_train_4])
        file_writer.write_u_int(data[:pilot_bomber_train_1])
        file_writer.write_u_int(data[:pilot_bomber_train_2])
        file_writer.write_u_int(data[:pilot_bomber_train_3])
        file_writer.write_u_int(data[:pilot_bomber_train_4])

        file_writer.write_byte(data[:connect_1])
        file_writer.write_byte(data[:connect_2])
        file_writer.write_byte(data[:connect_3])
        file_writer.write_byte(data[:connect_4])
        file_writer.write_byte(data[:connect_5])
        file_writer.write_byte(data[:read_level_1])
        file_writer.write_byte(data[:read_level_2])
        file_writer.write_byte(data[:read_level_3])
        file_writer.write_byte(data[:read_level_4])
        file_writer.write_byte(data[:read_level_5])

        data[:scout].each do |v|
          file_writer.skip(2)
          file_writer.write_u_short(v[:distance])
          file_writer.skip(2)
          file_writer.skip(4)
        end

        file_writer.write_u_short(data[:create_avility])
        file_writer.write_byte(data[:fixed_num])
        file_writer.skip(6)

        file_writer.write_string(data[:kana], 21)
      end
    end
  end
end

# jsonが整形できないのは負の数値があるため
