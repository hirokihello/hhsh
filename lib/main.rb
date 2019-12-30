#!/usr/bin/env ruby
require 'func/loop'

module Hhsh
  class Cli
    extend Hhsh::Loop
    def self.init
      # hhsh_loop()
      # exit()
      test_pipe()
    end

    def self.test_pipe()
      cmd1 = ["cat", "Makefile"]
      cmd2 = ["head"]
      cmds = [cmd1, cmd2]
      cmds_length = cmds.length

      # child_pid = fork
      # r, w = IO.pipe
      # if child_pid
      #   # 親
      #   puts("parent before wait")
      #   Process.waitpid(child_pid)
      #   # exec(cmds[0].join(" "))
      #   $stdin = "Makefile"
      #   exec("cat")
      #   puts "cat をした"
      #   exit(true)
      # else
      #   # 子
      #   puts "child"
      #   # $stdout = w
      #   # exec(cmds[1].join(" "))
      #   exit
      # end
      puts "hoge"
      $stdin = "Makefile"
      exec("cat")
      puts "cat をした"
      exit(true)
    end
  end
end
