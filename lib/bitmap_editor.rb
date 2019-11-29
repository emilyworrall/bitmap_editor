require_relative "models/bitmap"

class BitmapEditor
  COMMANDS = ["I", "C", "L", "V", "H", "S"]

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    commands = File.open(file)

    unless commands.first.start_with?("I")
      return puts "first command must be create"
    end

    commands.rewind

    commands.each do |line|
      command, *args = line.chomp.split
      return puts "unrecognised command :(" unless COMMANDS.include?(command)

      case command
      when "I"
        cols, rows = args
        @bitmap = Bitmap.new(rows.to_i, cols.to_i)
      when "L"
        row, col, colour = args
        @bitmap.colour_pixel([row.to_i, col.to_i], colour)
      when "V"
        col, start_row, end_row, colour = args
        @bitmap.draw_vertical(col.to_i, start_row.to_i, end_row.to_i, colour)
      when "H"
        start_col, end_col, row, colour = args
        @bitmap.draw_horizontal(row.to_i, start_col.to_i, end_col.to_i, colour)
      when "C"
        @bitmap.clear
      when "S"
        puts @bitmap.display_current_image
      end
    end
  end
end
