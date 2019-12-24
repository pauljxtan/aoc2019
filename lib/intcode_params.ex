defmodule IntcodeParams do
  defstruct idx: 0,
            inputs: [],
            outputs: [],
            loop_mode: false,
            rel_base: 0,
            return_val: :outputs,
            robot_mode: false,
            robot_position: nil,
            robot_direction: nil,
            robot_panels: nil
end
