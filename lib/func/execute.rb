# frozen_string_literal: true

require 'func/command'

BUILTIN_STR_HASH = {
  "cd" => :hhsh_cd,
  'pwd' => :hhsh_pwd,
  "ls" => :hhsh_ls
}.freeze

module Hhsh
  module Execute
    include Hhsh::Command

    def hhsh_execute(cmds)
      return true if cmds.empty?

      cmds.length > 1 ? pipe_func(0, cmds) : execute_cmds(cmds[0])
      true
    end

    # どの部分の関数を発火させるのかのint iと、cmmands群のarrayであるarray cmds
    def pipe_func(i, cmds)
      cmds_length = cmds.length

      # 再帰の回数がコマンド総数に達した場合、一番左のコマンドを発火させる
      exec(cmds[0]) if i == (cmds_length - 1)

      r, w = IO.pipe

      child_pid = fork do
        # 子
        $stdout.reopen(w)
        w.close
        pipe_func(i + 1, cmds)
      end
      # 親の処理
      Process.waitpid(child_pid)

      $stdin.reopen(r)
      r.close
      execute_cmds(cmds[cmds_length - i - 1], true)
      exit() unless 0 == i
    end

    # 返り値はboolean
    def execute_cmds(cmd, pipe=false)
      cmd_element = cmd.split(' ')
      command = cmd_element[0]
      cmd_args = cmd_element.drop(1)

      exit() if command == 'exit'

      # BUILTIN_STR_HASH[cmd]でcmdのvalueが見つからなければそのままexecする。
      BUILTIN_STR_HASH[command] ?
      method(BUILTIN_STR_HASH[command]).call(*cmd_args) : launch_interpreter(cmd_element, pipe)
    end

    def launch_interpreter(cmd, pipe=false)
      command = cmd.join(' ')
      interpreter_exec(command) if pipe

      child_pid = fork do
        interpreter_exec(command)
      end

      Process.waitpid(child_pid)
      true
    end

    def interpreter_exec(cmd)
      begin
        exec(cmd)
      rescue Errno::ENOENT
        puts 'unknown hommand for hhsh'
        exit()
      end
    end
  end
end
# cat Makefile | grep run