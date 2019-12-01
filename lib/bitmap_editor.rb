require_relative "models/bitmap"

class BitmapEditor
  class InvalidCommandError < StandardError; end
  COMMANDS_AND_ARG_SPEC = {
    "I" => [:num, :num],
    "C" => [],
    "L" => [:num, :num, :letter],
    "V" => [:num, :num, :num, :letter],
    "H" => [:num, :num, :num, :letter],
    "S" => []
  }.freeze

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    commands = File.open(file)

    unless commands.first.start_with?("I")
      return puts "first command must be create"
    end

    commands.rewind
    execute_commands(commands)
  end

  private

  def execute_commands(commands)
    commands.each_with_index do |line, line_num|
      begin
        command, *args = line.chomp.split
        unless COMMANDS_AND_ARG_SPEC.keys.include?(command)
          return puts "line #{line_num + 1}: unrecognised command"
        end

        command_args = validate_and_parse_args(command, args)

        case command
        when "I"
          @bitmap = Bitmap.new(*command_args)
        when "L"
          @bitmap.colour_pixel(*command_args)
        when "V"
          @bitmap.draw_vertical(*command_args)
        when "H"
          @bitmap.draw_horizontal(*command_args)
        when "C"
          @bitmap.clear
        when "S"
          puts @bitmap.display_current_image
        end

      rescue InvalidCommandError => e
        return puts "line #{line_num + 1}: #{e.message}"
      end
    end
  end

  def validate_and_parse_args(command, args)
    command_spec = COMMANDS_AND_ARG_SPEC[command]

    unless command_spec.count == args.count
      raise InvalidCommandError.new(
        "wrong number of arguments, requires #{command_spec.count}"
      )
    end

    args.map.with_index { |arg, index|
      case command_spec[index]
      when :num
        begin
          int = Integer(arg)
        rescue ArgumentError
          raise InvalidCommandError.new("argument #{index} must be number")
        end

        unless int > 0 && int <= 250
          raise InvalidCommandError.new("numbers must be between 1 and 250")
        end

        int
      when :letter
        unless arg.match(/^[A-Z]$/)
          raise InvalidCommandError.new("colour must be capital letter")
        end

        arg
      end
    }
  end
end
