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

  def colour_pixel(coordinate, colour)
    grid[coordinate] = colour
  end

  def draw_vertical(col, start_row, end_row, colour)
    rows = (start_row..end_row).to_a
    selected_coordinates = rows.map { |row| [col, row] }

    set_pixels_to_colour(selected_coordinates, colour)
  end

  def draw_horizontal(row, start_col, end_col, colour)
    cols = (start_col..end_col).to_a
    selected_coordinates = cols.map { |col| [col, row] }

    set_pixels_to_colour(selected_coordinates, colour)
  end

  def display_current_image
    grid
      .group_by { |coord, _| coord.last }
      .map { |_, row| row.to_h.values.join }
  end

  def clear
    set_pixels_to_colour(grid.keys, WHITE)
  end

  private

  def initialize_grid
    coordinates = []

    (1..cols).each do |x|
      (1..rows).each do |y|
        coordinates.push([x, y])
      end
    end

    set_pixels_to_colour(coordinates, WHITE)
  end

  def set_pixels_to_colour(coordinates, colour)
    coordinates.each do |coord|
      colour_pixel(coord, colour)
    end
  end
end
