class Bitmap
  WHITE = "O".freeze

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @grid = {}

    initialize_grid
  end

  attr_reader :rows, :cols, :grid
  private :rows, :cols

  private

  def initialize_grid
    coordinates = []

    (1..cols).each do |x|
      (1..rows).each do |y|
        coordinates.push([x, y])
      end
    end

    coordinates.each do |coordinate|
      grid[coordinate] = WHITE
    end
  end
end
