defmodule Aoc2019.Day8 do
  import Utils

  @behaviour DaySolution

  @input_width 25
  @input_height 6
  @black 0
  @white 1
  @transparent 2

  def solve_part1() do
    layer =
      image_data()
      |> parse_layers(@input_width, @input_height)
      |> Enum.min_by(fn layer -> layer |> Enum.count(fn digit -> digit == 0 end) end)

    (layer |> Enum.count(fn digit -> digit == 1 end)) *
      (layer |> Enum.count(fn digit -> digit == 2 end))
  end

  def solve_part2(), do: image_data() |> decode_image(@input_width, @input_height)

  def image_data(), do: load_delim_ints("inputs/input_day8", "")

  def parse_layers(data, width, height), do: data |> Enum.chunk_every(width * height)

  def decode_image(data, width, height) do
    layers = data |> parse_layers(width, height)

    for(
      position <- 0..(width * height - 1),
      do: layers |> pixel_layer(position) |> colour_of_pixel()
    )
    |> Enum.chunk_every(width)
  end

  def pixel_layer(layers, position),
    do: layers |> Enum.map(fn layer -> layer |> Enum.at(position) end)

  # First occurrence of black or white determines the colour
  # If neither occurs, pixel is transparent
  def colour_of_pixel(pixel_layer) do
    first_black_idx = pixel_layer |> Enum.find_index(&(&1 == @black))
    first_white_idx = pixel_layer |> Enum.find_index(&(&1 == @white))

    case first_black_idx do
      nil ->
        case first_white_idx do
          nil -> @transparent
          _ -> @white
        end

      b ->
        case first_white_idx do
          nil -> @black
          w -> if b < w, do: @black, else: @white
        end
    end
  end
end
