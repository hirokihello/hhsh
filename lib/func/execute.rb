# frozen_string_literal: true

require 'func/command'

BUILTIN_STR_HASH = {
  'cd' => :hhsh_cd,
  'pwd' => :hhsh_pwd,
  'ls' => :hhsh_ls
}.freeze

module Hhsh
  module Execute
    include Hhsh::Command

    def hhsh_execute(cmds)
      return true if cmds.empty?

      cmds.length > 1 ? pipe_execution(0, cmds) : execute_cmds(cmds[0])
      true
    end

    # どの部分の関数を発火させるのかのint iと、cmmands群のarrayであるarray cmds, forkされる親から渡される書き込み用パイプw_pipe
    def pipe_execution(i, cmds, w_pipe = nil)
      cmds_length = cmds.length

      # 再帰の回数がコマンド総数に達した場合、一番左のコマンドを発火させる
      if i == (cmds_length - 1)
        pipes = {
          w: w_pipe
        }
        execute_cmds(cmds[0], pipes)
      else
        r, w = IO.pipe

        pipe_child_pid = fork do
          # 子
          pipe_execution(i + 1, cmds, w)
          exit
        end

        # forkされたら親となる時の処理
        Process.waitpid(pipe_child_pid)

        pipes = {
          r: r,
          w: w_pipe
        }

        # execute_cmdsする際に入力を閉じるために書き込みがわのパイプを閉じる
        w.close

        child_pid = fork do
          execute_cmds(cmds[cmds_length - i - 1], pipes)
          exit
        end

        Process.waitpid(child_pid)
        exit unless i.zero?
      end
    end

    # 返り値はboolean
    def execute_cmds(cmd, pipes = {})
      cmd_element = cmd.split(' ')
      command = cmd_element[0]
      cmd_args = cmd_element.drop(1)

      exit if command == 'exit'

      # BUILTIN_STR_HASH[cmd]でcmdのvalueが見つからなければそのままexecする。
      BUILTIN_STR_HASH[command] ?
        execute_builtin_command(BUILTIN_STR_HASH[command], cmd_args, pipes)
        : launch_interpreter(cmd_element, pipes)
    end

    def execute_builtin_command(command, cmd_args, pipes = {})
      set_pipes(pipes)

      method(BUILTIN_STR_HASH[command]).call(*cmd_args)
      true
    end

    def launch_interpreter(cmd, pipes = {})
      command = cmd.join(' ')

      child_pid = fork do
        begin
          set_pipes(pipes)
          exec(command)
        rescue Errno::ENOENT
          puts 'unknown hommand for hhsh'
          exit
        end
      end

      Process.waitpid(child_pid)
      true
    end

    def set_pipes(pipes = {})
      if pipes[:r]
        $stdin.reopen(pipes[:r])
        pipes[:r].close
        $stdin.close
      end

      if pipes[:w]
        $stdout.reopen(pipes[:w])
        pipes[:w].close
      end
    end
  end
end
