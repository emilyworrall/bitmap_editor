require "spec_helper"
require "bitmap_editor"

RSpec.describe "Creating a bitmap" do
  subject(:bitmap_editor) { BitmapEditor.new }

  before do
    allow(STDOUT).to receive(:puts)
  end

  after do
    File.delete(input_filename) if File.exists?(input_filename)
  end

  describe "Creating a bitmap with multiple edits" do
    it "successfully creates a bitmap" do
      create_file(
        [
          "I 5 6",
          "L 1 3 A",
          "C",
          "L 1 3 B",
          "V 2 3 6 W",
          "H 3 5 2 Z",
          "S"
        ]
      )
      bitmap_editor.run(input_filename)

      expect(STDOUT).to have_received(:puts).with(
        [
          "OOOOO",
          "OOZZZ",
          "BWOOO",
          "OWOOO",
          "OWOOO",
          "OWOOO"
        ]
      )
    end
  end

  def create_file(lines)
    File.open(input_filename, "w+") do |file|
      file.puts(lines)
    end
  end

  def input_filename
    "examples/test.txt"
  end
end
