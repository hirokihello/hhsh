require 'func/command'

BUILTIN_STR_HASH =  {
  # "cd" => :hhsh_cd,
  "pwd" => :hhsh_pwd,
  # "ls" => :hhsh_ls
}.freeze

module Hhsh
  module Execute
    include Hhsh::Command

    def hhsh_execute(args)
      # return true if args.empty?
      # idx = 0
      # cmd = args[0]

      # return false if cmd == "exit"
      # cmd_args = args.drop(1)

      # return launch_interpreter(args) unless BUILTIN_STR_HASH[cmd]

      # method(BUILTIN_STR_HASH[cmd]).call(*cmd_args)

      # child_pidは親プロセスの場合、子プロセスのpid, 子プロセスの場合はnilが代入されている
      child_pid = fork
      if child_pid
        Process.waitpid(child_pid)
      else
        do_pipes(0)
      end
    end

    def do_pipes(i)
      # cat Makefile | head | grep run
      cmd1 = ["cat", "Makefile"]
      cmd2 = ["head"]
      # cmd3 = ["grep", "run"]
      # cmds = [cmd1, cmd2, cmd3]
      cmds = [cmd1, cmd2]
      cmds_length = cmds.length

      child_pid = fork
      r, w = IO.pipe
      if child_pid
        # 親
        puts("parent before wait")
        Process.waitpid(child_pid)

        puts("parent")
        $stdin = r
        # exec(cmds[0].join(" "))
        puts r
      else
        # 子
        puts "child"
        $stdout = w
        exec(cmds[1].join(" "))
        puts "hoge"
        exit(true)
      end
      exit(true)
    end

    def launch_interpreter(cmd)
      command = cmd.join(" ")
      child_pid = fork do
        begin
          exec(command)
        rescue Errno::ENOENT
          puts "unknown hommand for hhsh"
        end
        exit(true)
      end
      Process.waitpid(child_pid)

      true
    end
  end
end
