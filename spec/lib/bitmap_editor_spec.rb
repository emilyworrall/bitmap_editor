require "spec_helper"
require "bitmap_editor"

RSpec.describe BitmapEditor do
  subject(:bitmap_editor) { BitmapEditor.new }
  let(:commands) { [] }

  before do
    allow(STDOUT).to receive(:puts)
    create_file(commands)
  end

  after do
    File.delete(input_filename) if File.exists?(input_filename)
  end

  describe "#run" do
    describe "invalid user input" do
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
        let(:commands) { ["I 1 1", "P"] }

        it "outputs error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with("line 2: unrecognised command")
        end
      end

      context "when first line in file isn't a create command" do
        let(:commands) { ["P"] }

        it "outputs error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with("first command must be create")
        end
      end

      context "when a number argument is not between 1 and 250" do
        let(:commands) { ["I 3 3", "L 1 560 C"] }

        it "outputs an error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(
            "line 2: numbers must be between 1 and 250"
          )
        end
      end

      context "when colour and number args are in the wrong position" do
        let(:commands) { ["I 3 3", "L C 1 1"] }

        it "outputs an error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(
            "line 2: argument 0 must be number"
          )
        end
      end

      context "when command has invalid number of arguments" do
        let(:commands) { ["I 3 3", "H 1"] }

        it "outputs an error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(
            "line 2: wrong number of arguments, requires 4"
          )
        end
      end

      context "when colour argument isn't a capital letter" do
        let(:commands) { ["I 3 3", "S", "H 1 1 2 f"] }

        it "outputs an error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(
            "line 3: colour must be capital letter"
          )
        end
      end

      context "when a bitmap image already exists" do
        let(:commands) { ["I 3 3", "I 3 4"] }

        it "outputs an error message" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(
            "line 2: bitmap image already exists"
          )
        end
      end
    end

    describe "valid user input" do
      let(:bitmap) {
        instance_double(
          "Bitmap",
          colour_pixel: true,
          draw_vertical: true,
          draw_horizontal: true,
          clear: true,
          display_current_image: current_image
        )
      }
      let(:current_image) { ["OOO", "OOO", "OOO"] }

      before do
        allow(Bitmap).to receive(:new).and_return(bitmap)
      end

      describe "creating a bitmap" do
        let(:commands) { ["I 3 3"] }

        it "creates a new Bitmap" do
          bitmap_editor.run(input_filename)

          expect(Bitmap).to have_received(:new).with(3, 3)
        end
      end

      describe "editing a pixel on the bitmap" do
        let(:commands) { ["I 3 3", "L 1 2 C"] }

        it "colours the pixel with specified colour" do
          bitmap_editor.run(input_filename)

          expect(bitmap).to have_received(:colour_pixel).with(1, 2, "C")
        end
      end

      describe "drawing a vertical segment of colour on image" do
        let(:commands) { ["I 3 3", "V 1 1 3 C"] }

        it "calls Bitmap draw_vertical method" do
          bitmap_editor.run(input_filename)

          expect(bitmap).to have_received(:draw_vertical).with(1, 1, 3, "C")
        end
      end

      describe "drawing a horizontal segment of colour on image" do
        let(:commands) { ["I 3 3", "H 1 3 1 C"] }

        it "calls Bitmap draw_horizontal method" do
          bitmap_editor.run(input_filename)

          expect(bitmap).to have_received(:draw_horizontal).with(1, 3, 1, "C")
        end
      end

      describe "clearing the image" do
        let(:commands) { ["I 3 3", "H 1 3 1 C", "C"] }

        it "calls Bitmap clear method" do
          bitmap_editor.run(input_filename)

          expect(bitmap).to have_received(:clear)
        end
      end

      describe "showing contents of current image" do
        let(:commands) { ["I 3 3", "S"] }

        it "calls Bitmap display_current_image method" do
          bitmap_editor.run(input_filename)

          expect(bitmap).to have_received(:display_current_image)
        end

        it "sends displayed Bitmap to STDOUT" do
          bitmap_editor.run(input_filename)

          expect(STDOUT).to have_received(:puts).with(current_image)
        end
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
