require "spec_helper"
require "bitmap_editor"

RSpec.describe BitmapEditor do
  subject(:bitmap_editor) { BitmapEditor.new }

  before do
    allow(STDOUT).to receive(:puts)
  end

  after do
    File.delete(input_filename) if File.exists?(input_filename)
  end

  describe "#run" do
    context "when no file is provided" do
      it "outputs error message" do
        bitmap_editor.run(nil)

        expect(STDOUT).to have_received(:puts).with("please provide correct file")
      end
    end

    context "when filename is provided but doesn't exist" do
      it "outputs error message" do
        bitmap_editor.run("examples/random.txt")

        expect(STDOUT).to have_received(:puts).with("please provide correct file")
      end
    end

    context "when file contains unrecognised command" do
      it "outputs error message" do
        lines = ["I", "P"]
        create_file(lines)
        bitmap_editor.run(input_filename)

        expect(STDOUT).to have_received(:puts).with("unrecognised command :(")
      end
    end

    context "when first line in file isn't a create command" do
      it "outputs error message" do
        lines = ["P"]
        create_file(lines)
        bitmap_editor.run(input_filename)

        expect(STDOUT).to have_received(:puts).with("first command must be create")
      end
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
