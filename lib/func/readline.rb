# frozen_string_literal: true

require 'readline'

module Hhsh
  module ReadlineFunc
    def hhsh_read_line
      Readline.readline("hhsh > #{Dir.pwd} >> ", true)
    end
  end
end
