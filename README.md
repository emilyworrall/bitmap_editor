# Bitmap editor

This is a program that simulates a basic interactive bitmap editor.
Bitmaps are represented as an M x N matrix of pixels with each element representing a colour.

## Prerequisites

- Ruby v2.6.5

## Setup

- `bundle install`

## Testing

- `bundle exec rspec`

## Running

### Edit input file

This script takes an input file containing a list of commands.
There are 6 supported commands:

- `I N M` - Creates a new M x N image with all pixels coloured white (O).
- `C` - Clears the table, setting all pixels to white (O).
- `L X Y C` - Colours the pixel (X, Y) with colour C.
- `V X Y1 Y2 C` - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
- `H X1 X2 Y C` - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
- `S` - Show the contents of the current image.

### Run script

`>bin/bitmap_editor examples/show.txt`
