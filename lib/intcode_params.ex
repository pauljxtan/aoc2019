defmodule IntcodeParams do
  defstruct idx: 0,
            inputs: [],
            outputs: [],
            loop_mode: false,
            rel_base: 0,
            return_val: :outputs,
            robot_mode: false,
            robot_position: {0, 0},
            robot_direction: :up,
            robot_panels: %{},
            arcade_mode: false,
            arcade_tiles: %{}
end
