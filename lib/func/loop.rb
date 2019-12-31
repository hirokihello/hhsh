# frozen_string_literal: true

require 'func/readline'
require 'func/execute'
require 'func/split_line'

module Hhsh
  module Loop
    include Hhsh::ReadlineFunc
    include Hhsh::SplitLine
    include Hhsh::Execute
    def hhsh_loop
      status = true

      while status
        line = hhsh_read_line
        args = hhsh_split_line(line)
        status = hhsh_execute(args)
      end
    end
  end
end
