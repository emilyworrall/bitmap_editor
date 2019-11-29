require "spec_helper"
require "models/bitmap"

RSpec.describe Bitmap do
  subject(:bitmap) { Bitmap.new(rows, cols) }
  let(:rows) { 3 }
  let(:cols) { 3 }

  describe "#new" do
    it "creates a grid of specified row and col size" do
      expect(bitmap.grid.count).to eq(rows * cols)
    end

    it "fills all grid coordinates with colour white 'O'" do
      expect(bitmap.grid.values.all?("O")).to eq(true)
    end
  end

  describe "#colour_pixel" do
    it "colours pixel at given coordinate with given colour" do
      bitmap.colour_pixel(1, 2, "C")

      expect(bitmap.grid[[1, 2]]).to eq("C")
    end
  end

  describe "#draw_vertical" do
    it "colours a vertical line in given column across specified rows" do
      bitmap.draw_vertical(1, 1, 3, "C")

      expect(bitmap.grid).to eq(
        {
          [1, 1] => "C", [1, 2] => "C", [1, 3] => "C",
          [2, 1] => "O", [2, 2] => "O", [2, 3] => "O",
          [3, 1] => "O", [3, 2] => "O", [3, 3] => "O"
        }
      )
    end
  end

  describe "#draw_horizontal" do
    it "colours a horizontal line in given row across specified columns" do
      bitmap.draw_horizontal(1, 1, 3, "C")

      expect(bitmap.grid).to eq(
        {
          [1, 1] => "C", [1, 2] => "O", [1, 3] => "O",
          [2, 1] => "C", [2, 2] => "O", [2, 3] => "O",
          [3, 1] => "C", [3, 2] => "O", [3, 3] => "O"
        }
      )
    end
  end

  describe "#display_current_image" do
    it "returns array containing each row of colours" do
      bitmap.draw_vertical(1, 1, 3, "C")

      expect(bitmap.display_current_image).to eq(
        ["COO", "COO", "COO"]
      )
    end
  end
end
