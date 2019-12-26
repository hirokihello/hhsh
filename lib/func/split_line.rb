module Hhsh
  module SplitLine
    def hhsh_split_line(line)
      return [] if line.empty?

      line.split(" ")
    end
  end
end
