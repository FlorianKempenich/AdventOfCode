defmodule Solution.Day3 do
  @moduledoc """
  --- Part One ---
  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

  The number of inches between the left edge of the fabric and the left edge of the rectangle.
  The number of inches between the top edge of the fabric and the top edge of the rectangle.
  The width of the rectangle in inches.
  The height of the rectangle in inches.
  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........
  The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........
  The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?


  --- Part Two ---
  """
  alias __MODULE__.ClaimedArea
  alias __MODULE__.FabricCoordinates
  alias __MODULE__.ClaimedCoordinates

  @behaviour Solution

  @type id() :: non_neg_integer | :unset

  defmodule FabricCoordinates do
    @moduledoc """
    Coordinates are given with a `y` axis pointing downwards
    """
    defstruct [:x, :y]
  end

  defmodule ClaimedCoordinates do
    @type t :: %__MODULE__{
            coordinates: %FabricCoordinates{},
            claimed_by: list(Day3.id())
          }
    defstruct [:coordinates, :claimed_by]
  end

  defmodule ClaimedArea do
    @moduledoc """
    Coordinates are given with a `y` axis pointing downwards
    """
    @type t :: %__MODULE__{
            id: Day3.id(),
            top_left: %FabricCoordinates{},
            width: non_neg_integer,
            height: non_neg_integer
          }
    defstruct [
      :id,
      :top_left,
      :width,
      :height
    ]

    def from_string(claim_as_string) do
      ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
      |> Regex.run(claim_as_string, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
      |> to_claimed_area()
    end

    defp to_claimed_area([id, top_left_x, top_left_y, width, height]),
      do: %ClaimedArea{
        id: id,
        top_left: %FabricCoordinates{x: top_left_x, y: top_left_y},
        width: width,
        height: height
      }

    @spec all_claimed_coordinates(ClaimedArea.t()) :: [ClaimedCoordinates.t()]
    def all_claimed_coordinates(%ClaimedArea{
          id: id,
          top_left: top_left,
          width: width,
          height: height
        }) do
      for x_coordinate_in_area <- 0..(width - 1),
          y_coordinate_in_area <- 0..(height - 1) do
        %ClaimedCoordinates{
          coordinates: %FabricCoordinates{
            x: top_left.x + x_coordinate_in_area,
            y: top_left.y + y_coordinate_in_area
          },
          claimed_by: [id]
        }
      end
    end
  end

  @doc """
  """
  def solve_part_1(input_as_string) do
    input_as_string
    |> parse_claims()
    |> calculate_area_of_overlapping()
    |> Integer.to_string()
  end

  defp parse_claims(input_as_string) do
    input_as_string
    |> String.split(~r/\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&ClaimedArea.from_string/1)
  end

  defp calculate_area_of_overlapping(claimed_areas) do
    claimed_areas
    |> Enum.flat_map(&ClaimedArea.all_claimed_coordinates/1)
    |> merge_claims_at_each_coordinates()
    |> Enum.filter(&claimed_by_mode_than_one_person/1)
    |> Enum.count()
  end

  defp merge_claims_at_each_coordinates(claimed_coordinates) do
    claimed_coordinates
    |> Enum.group_by(fn %ClaimedCoordinates{coordinates: coordinates} ->
      coordinates
    end)
    |> Enum.map(fn {coordinates, claims_at_coordinates} ->
      all_id_claming_these_coordinates =
        claims_at_coordinates
        |> Enum.flat_map(&Map.get(&1, :claimed_by))

      %ClaimedCoordinates{
        coordinates: coordinates,
        claimed_by: all_id_claming_these_coordinates
      }
    end)
  end

  defp claimed_by_mode_than_one_person(%ClaimedCoordinates{claimed_by: claimed_by})
       when length(claimed_by) > 1,
       do: true

  defp claimed_by_mode_than_one_person(_), do: false


  @doc """
  """
  def solve_part_2(_input_as_string) do
    ""
  end
end
