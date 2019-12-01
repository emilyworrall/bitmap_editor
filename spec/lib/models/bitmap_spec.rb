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
    context "when beginning of row range is lower than end" do
      let(:start_row) { 1 }
      let(:end_row) { 3 }

      it "colours a vertical line in given column across specified rows" do
        bitmap.draw_vertical(1, start_row, end_row, "C")

        expect(bitmap.grid).to eq(
          {
            [1, 1] => "C", [1, 2] => "C", [1, 3] => "C",
            [2, 1] => "O", [2, 2] => "O", [2, 3] => "O",
            [3, 1] => "O", [3, 2] => "O", [3, 3] => "O"
          }
        )
      end
    end

    context "when beginning of row range is higher than end" do
      let(:start_row) { 3 }
      let(:end_row) { 1 }

      it "colours a vertical line in given column across specified rows" do
        bitmap.draw_vertical(1, start_row, end_row, "C")

        expect(bitmap.grid).to eq(
          {
            [1, 1] => "C", [1, 2] => "C", [1, 3] => "C",
            [2, 1] => "O", [2, 2] => "O", [2, 3] => "O",
            [3, 1] => "O", [3, 2] => "O", [3, 3] => "O"
          }
        )
      end
    end
  end

  describe "#draw_horizontal" do
    context "when beginning of col range is lower than end" do
      let(:start_col) { 1 }
      let(:end_col) { 3 }

      it "colours a horizontal line in given row across specified columns" do
        bitmap.draw_horizontal(start_col, end_col, 1, "C")

        expect(bitmap.grid).to eq(
          {
            [1, 1] => "C", [1, 2] => "O", [1, 3] => "O",
            [2, 1] => "C", [2, 2] => "O", [2, 3] => "O",
            [3, 1] => "C", [3, 2] => "O", [3, 3] => "O"
          }
        )
      end
    end

    context "when beginning of col range is higher than end" do
      let(:start_col) { 3 }
      let(:end_col) { 1 }

      it "colours a horizontal line in given row across specified columns" do
        bitmap.draw_horizontal(start_col, end_col, 1, "C")

        expect(bitmap.grid).to eq(
          {
            [1, 1] => "C", [1, 2] => "O", [1, 3] => "O",
            [2, 1] => "C", [2, 2] => "O", [2, 3] => "O",
            [3, 1] => "C", [3, 2] => "O", [3, 3] => "O"
          }
        )
      end
    end
  end

  describe "#clear" do
    it "sets all pixels to white" do
      bitmap.colour_pixel(1, 2, "C")
      expect(bitmap.grid[[1, 2]]).to eq("C")

      bitmap.clear

      expect(bitmap.grid.values.all?("O")).to eq(true)
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

  context "when trying to colour a coordinate outside of the grid" do
    it "raises an error" do
      expect {
        bitmap.draw_vertical(1, 1, 6, "C")
      }.to raise_error(
        Bitmap::OutOfBoundsError, "trying to colour outside of bitmap"
      )
    end
  end
end
