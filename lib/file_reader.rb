class FileReader
  def initialize(file)
    @file = file
  end

  def read_byte
    @file.read(1).unpack('C').first
  end

  def read_short
    @file.read(2).unpack('s').first
  end

  def read_u_short
    @file.read(2).unpack('S').first
  end

  def read_int
    @file.read(4).unpack('i').first
  end

  def read_u_int
    @file.read(4).unpack('I').first
  end

  def read_string(length)
    @file.read(length).force_encoding('SJIS').encode('UTF-8').gsub(/\u0000/, '')
  end

  def skip(length)
    @file.read(length)
    nil
  end
end