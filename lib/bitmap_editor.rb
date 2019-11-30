require_relative "models/bitmap"

class BitmapEditor
  class InvalidNumberOfArguments < StandardError; end
  COMMANDS_AND_NO_OF_ARGS = {
    "I" => 2, "C" => 0, "L" => 3, "V" => 4, "H" => 4, "S" => 0
  }

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    commands = File.open(file)

    unless commands.first.start_with?("I")
      return puts "first command must be create"
    end

    commands.rewind

    commands.each_with_index do |line, line_num|
      begin
        command, *args = line.chomp.split
        unless COMMANDS_AND_NO_OF_ARGS.keys.include?(command)
          return puts "unrecognised command :("
        end

        validate_number_of_args(command, args)

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

      rescue InvalidNumberOfArguments => e
        return puts "line #{line_num + 1}: wrong number of arguments"
      end
    end
  end

  private

  def validate_number_of_args(command, args)
    return if COMMANDS_AND_NO_OF_ARGS[command] == args.count
    raise InvalidNumberOfArguments.new
  end
end
