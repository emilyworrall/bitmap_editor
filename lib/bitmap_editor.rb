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
      when "S"
        puts "There is no image"
      end
    end
  end
end
