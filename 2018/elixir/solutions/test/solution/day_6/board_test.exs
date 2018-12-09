defmodule Solution.Day6.BoardTest do
  use ExUnit.Case
  alias Solution.Day6.Board
  alias Solution.Day6.Board.InvalidBoard
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.GridString

  describe "Build from Grid" do
    test "Areas already grown - Raise error" do
      grid_with_with_areas_not_at_stage_0 =
        """
        |   | 1 |   |   |   |   |   |
        | 1 | 0 | 1 |   |   |   |   |
        |   | 1 |   |   |   |   |   |
        |   |   |   | 1 |   |   |   |
        |   |   | 1 | 0 | 1 |   |   |
        |   |   |   | 1 |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()

      assert_raise InvalidBoard, fn ->
        Board.from_grid_string(grid_with_with_areas_not_at_stage_0)
      end
    end

    test "Single Area" do
      grid =
        """
        |   |   |   |   |   |   |   |
        |   | 0 |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()

      board = Board.from_grid_string(grid)

      assert board.areas == [ClosestPointsArea.from_origin({1, 1})]
    end

    test "Multiple Area" do
      grid =
        """
        |   |   |   |   |   |   |   |
        |   | 0 |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   | 0 |   |   |   |   |
        |   |   |   |   |   | 0 |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()

      board = Board.from_grid_string(grid)

      assert board.areas == [
               ClosestPointsArea.from_origin({1, 1}),
               ClosestPointsArea.from_origin({2, 4}),
               ClosestPointsArea.from_origin({5, 5})
             ]
    end
  end

  describe "To Grid" do
    test "- 2 Areas - No Equidistants" do
      area_1 =
        """
        |   |   | 2 |   |   |   |   |
        |   | 2 | 1 | 2 |   |   |   |
        | 2 | 1 | 0 | 1 |   |   |   |
        |   | 2 | 1 |   |   |   |   |
        |   |   | 2 |   |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      area_2 =
        """
        |   |   |   |   |   |   |   |
        |   |   |   |   | 2 |   |   |
        |   |   |   |   | 1 | 2 |   |
        |   |   |   | 1 | 0 | 1 | 2 |
        |   |   |   | 2 | 1 | 2 |   |
        |   |   |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      board = %Board{areas: [area_1, area_2]}

      assert Board.to_grid_string(board) ==
               """
               |   |   | 2 |   |   |   |   |
               |   | 2 | 1 | 2 | 2 |   |   |
               | 2 | 1 | 0 | 1 | 1 | 2 |   |
               |   | 2 | 1 | 1 | 0 | 1 | 2 |
               |   |   | 2 | 2 | 1 | 2 |   |
               |   |   |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end

    test "- 2 Areas - Equidistants Points" do
      area_1 =
        """
        |   |   | 2 |   |   |   |   |
        |   | 2 | 1 | 2 |   |   |   |
        | 2 | 1 | 0 | 1 | 2 |   |   |
        |   | 2 | 1 | 2 |   |   |   |
        |   |   | 2 |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      area_2 =
        """
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   | 2 |   |   |
        |   |   |   | 2 | 1 | 2 |   |
        |   |   | 2 | 1 | 0 | 1 | 2 |
        |   |   |   | 2 | 1 | 2 |   |
        |   |   |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      board = %Board{areas: [area_1, area_2]}

      assert Board.to_grid_string(board) ==
               """
               |   |   | 2 |   |   |   |   |
               |   | 2 | 1 | 2 |   |   |   |
               | 2 | 1 | 0 | 1 | . |   |   |
               |   | 2 | 1 | . | 1 | 2 |   |
               |   |   | . | 1 | 0 | 1 | 2 |
               |   |   |   | 2 | 1 | 2 |   |
               |   |   |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end

    test "- Multiple Areas - With Equidistant" do
      area_1 =
        """
        |   |   | 2 |   |   |   |   |   |   |
        |   | 2 | 1 | 2 |   |   |   |   |   |
        | 2 | 1 | 0 | 1 |   |   |   |   |   |
        |   | 2 | 1 |   |   |   |   |   |   |
        |   |   | 2 |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      area_2 =
        """
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   | 2 |   |   |   |   |
        |   |   |   |   | 1 | 2 |   |   |   |
        |   |   |   | 1 | 0 | 1 | 2 |   |   |
        |   |   |   | 2 | 1 | 2 |   |   |   |
        |   |   |   |   | 2 |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      area_3 =
        """
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   | 2 |   |   |
        |   |   |   |   |   | 2 | 1 | 2 |   |
        |   |   |   |   | 2 | 1 | 0 | 1 | 2 |
        |   |   |   |   |   | 2 | 1 | 2 |   |
        |   |   |   |   |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      board = %Board{areas: [area_1, area_2, area_3]}

      assert Board.to_grid_string(board) ==
               """
               |   |   | 2 |   |   |   |   |   |   |
               |   | 2 | 1 | 2 | 2 |   |   |   |   |
               | 2 | 1 | 0 | 1 | 1 | 2 |   |   |   |
               |   | 2 | 1 | 1 | 0 | 1 | . |   |   |
               |   |   | 2 | 2 | 1 | . | 1 | 2 |   |
               |   |   |   |   | . | 1 | 0 | 1 | 2 |
               |   |   |   |   |   | 2 | 1 | 2 |   |
               |   |   |   |   |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end
  end

  describe "Grow Board" do
    test "- Single point" do
      board =
        """
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   | 0 |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()

      board_grown_3_times =
        board
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()

      assert Board.to_grid_string(board_grown_3_times) ==
               """
               |   |   |   | 3 |   |   |   |
               |   |   | 3 | 2 | 3 |   |   |
               |   | 3 | 2 | 1 | 2 | 3 |   |
               | 3 | 2 | 1 | 0 | 1 | 2 | 3 |
               |   | 3 | 2 | 1 | 2 | 3 |   |
               |   |   | 3 | 2 | 3 |   |   |
               |   |   |   | 3 |   |   |   |
               """
               |> GridString.from_string()
    end

    test "- 2 Points  - No intersection" do
      board =
        """
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   | 0 |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   | 0 |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()

      board_grown_2_times =
        board
        |> Board.grow()
        |> Board.grow()

      assert Board.to_grid_string(board_grown_2_times) ==
               """
               |   |   | 2 |   |   |   |   |   |  |
               |   | 2 | 1 | 2 |   |   |   |   |  |
               | 2 | 1 | 0 | 1 | 2 |   |   |   |  |
               |   | 2 | 1 | 2 |   |   | 2 |   |  |
               |   |   | 2 |   |   | 2 | 1 | 2 |  |
               |   |   |   |   | 2 | 1 | 0 | 1 | 2|
               |   |   |   |   |   | 2 | 1 | 2 |  |
               |   |   |   |   |   |   | 2 |   |  |
               """
               |> GridString.from_string()
    end

    # @tag :only
    test "- 2 Points  - Equidistant points" do
      board =
        """
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   | 0 |   |   |   | 0 |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()

      board_grown_2_times =
        board
        |> Board.grow()
        |> Board.grow()

      # Point at {x: 4, y; 2} is equidistant from both origins, therefore it is
      # excluded from both areas
      assert Board.to_grid_string(board_grown_2_times) ==
               """
               |   |   | 2 |   |   |   | 2 |   |  |
               |   | 2 | 1 | 2 |   | 2 | 1 | 2 |  |
               | 2 | 1 | 0 | 1 | . | 1 | 0 | 1 | 2|
               |   | 2 | 1 | 2 |   | 2 | 1 | 2 |  |
               |   |   | 2 |   |   |   | 2 |   |  |
               """
               |> GridString.from_string()
    end

    test "- 2 Points  - Bound / Points to grow into are already belonging to another Area" do
      board =
        """
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   | 0 |   |   |   |   |
        |   |   |   |   | 0 |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()

      board_grown_1_time_no_intersection_yet =
        board
        |> Board.grow()

      board_grown_2_times_areas_arent_overrunning_each_other =
        board
        |> Board.grow()
        |> Board.grow()

      assert Board.to_grid_string(board_grown_1_time_no_intersection_yet) ==
               """
               |   |   |   |   |   |   |
               |   |   | 1 |   |   |   |
               |   | 1 | 0 | 1 | 1 |   |
               |   |   | 1 | 1 | 0 | 1 |
               |   |   |   |   | 1 |   |
               """
               |> GridString.from_string()

      assert Board.to_grid_string(board_grown_2_times_areas_arent_overrunning_each_other) ==
               """
               |   |   | 2 |   |   |   |   |
               |   | 2 | 1 | 2 | 2 |   |   |
               | 2 | 1 | 0 | 1 | 1 | 2 |   |
               |   | 2 | 1 | 1 | 0 | 1 | 2 |
               |   |   | 2 | 2 | 1 | 2 |   |
               |   |   |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end

    test "Multiple points" do
      board =
        """
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   | 0 |   |   |   |   |   |   |
        |   |   |   |   | 0 |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   | 0 |   |   |
        |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()

      board_grown_1_time =
        board
        |> Board.grow()

      board_grown_2_times =
        board
        |> Board.grow()
        |> Board.grow()

      assert Board.to_grid_string(board_grown_1_time) ==
               """
               |   |   |   |   |   |   |   |   |
               |   |   | 1 |   |   |   |   |   |
               |   | 1 | 0 | 1 | 1 |   |   |   |
               |   |   | 1 | 1 | 0 | 1 |   |   |
               |   |   |   |   | 1 |   | 1 |   |
               |   |   |   |   |   | 1 | 0 | 1 |
               |   |   |   |   |   |   | 1 |   |
               """
               |> GridString.from_string()

      assert Board.to_grid_string(board_grown_2_times) ==
               """
               |   |   | 2 |   |   |   |   |   |   |
               |   | 2 | 1 | 2 | 2 |   |   |   |   |
               | 2 | 1 | 0 | 1 | 1 | 2 |   |   |   |
               |   | 2 | 1 | 1 | 0 | 1 | . |   |   |
               |   |   | 2 | 2 | 1 | . | 1 | 2 |   |
               |   |   |   |   | . | 1 | 0 | 1 | 2 |
               |   |   |   |   |   | 2 | 1 | 2 |   |
               |   |   |   |   |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end

    @tag :skip
    test "Board from Problem statement" do
      IO.puts("")

      grow_board =
        """
        |   |   |   |   |   |   |   |   |   |   |
        |   | 0 |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   | 0 |   |
        |   |   |   | 0 |   |   |   |   |   |   |
        |   |   |   |   |   | 0 |   |   |   |   |
        |   | 0 |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |   | 0 |   |
        """
        |> GridString.from_string()
        |> Board.from_grid_string()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()
        |> Board.grow()

      grow_board
      |> Map.get(:areas)
      |> Enum.filter(fn %{fully_grown?: grown?} -> grown? end)
      |> IO.inspect()

      grow_board
      |> Board.to_grid_string()
      |> IO.inspect()
    end
  end
end
