# frozen_string_literal: true

require "strscan"

module Hhsh
  module SplitLine
    def hhsh_split_line(line)
      s = ::StringScanner.new(line)
      cmds = []

      until s.eos?
        # 先頭の空白の削除
        s.scan(/ */)
        # コマンド部分の削除
        cmd = s.scan(/[^\|]*/)
        next if cmd.empty?

        cmds << cmd
        s.scan(/\|/)
      end

      return [] if line.empty?

      cmds
    end
  end
end
#  cat Makefile | echo
