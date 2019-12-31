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
      return true if args.empty?
      idx = 0
      cmd = args[0]

      return false if cmd == "exit"
      cmd_args = args.drop(1)

      return launch_interpreter(args) unless BUILTIN_STR_HASH[cmd]

      method(BUILTIN_STR_HASH[cmd]).call(*cmd_args)

      # child_pidは親プロセスの場合、子プロセスのpid, 子プロセスの場合はnilが代入されている
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
