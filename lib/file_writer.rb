class FileWriter
  def initialize(file)
    @file = file
  end

  def write_byte(data)
    @file.write([data].pack('C'))
  end

  def write_short(data)
    @file.write([data].pack('s'))
  end

  def write_u_short(data)
    @file.write([data].pack('S'))
  end

  def write_int(data)
    @file.write([data].pack('i'))
  end

  def write_u_int(data)
    @file.write([data].pack('I'))
  end

  def write_string(data, length)
    str = data.force_encoding('UTF-8').encode('SJIS')
    @file.write(str)
    @file.write("\x00" * (length - str.bytesize))
  end

  def skip(length)
    @file.seek(length, IO::SEEK_CUR)
  end
end