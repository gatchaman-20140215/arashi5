require 'excel_creator'

excel = File.join(__dir__, 'data', 'excel', '太平洋の嵐5.xlsx')
creater = ExcelCreator.new(excel).create
