# frozen_string_literal: true

require 'func/loop'

module Hhsh
  class Cli
    extend Hhsh::Loop
    def self.init
      hhsh_loop()
      exit()
    end
  end
end
