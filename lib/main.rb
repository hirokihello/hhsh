#!/usr/bin/env ruby
require 'func/loop'

module Hhsh
  class Cli
    extend Hhsh::Loop
    def self.init
      # hhsh_loop()
      # exit()
      test_pipe(0)
    end

    def self.test_pipe(i)
      # cat Makefile | head | grep run
      cmd1 = "cat Makefile"
      cmd2 = "head"
      cmd3 = "grep run"
      cmds = [cmd1, cmd2, cmd3]
      cmds_length = cmds.length

      # 再帰の回数がコマンド数に達した場合、一番左のコマンドを発火させる
      exec(cmds[0]) if i == (cmds_length - 1)

      r, w = IO.pipe()

      child_pid = fork do
        # 子
        # 標準出力先をwに置き換え
        $stdout.reopen(w)
        #処理が終わったら閉じる
        w.close()
        self.test_pipe(i + 1)
      end

      # 親の処理
      Process.waitpid(child_pid)

      # 標準入力をパイプに置き換え
      $stdin.reopen(r)
      r.close()

      exec(cmds[cmds_length - i - 1])
    end
  end
end
