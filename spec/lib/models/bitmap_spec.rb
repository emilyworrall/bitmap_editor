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
end
