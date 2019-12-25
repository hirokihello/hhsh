require "readline"

BUILTIN_STR_HASH =  {
  "cd" => :hhsh_cd,
  "pwd" => :hhsh_pwd,
  "ls" => :hhsh_ls
}.freeze

def hhsh_cd(dir="./")
  Dir.chdir(dir)

  true
end

def hhsh_pwd
  puts Dir.pwd

  true
end

def hhsh_ls(*args)
  options = *args

  target = options.empty? ? Dir.pwd : options[0]

  entries = Dir.children(target)

  puts entries

  true
end

def hhsh_launch(cmd)
  command = cmd.join(" ")
  child_pid = fork do
    begin
      exec(command)
    rescue Errno::ENOENT
      puts "unknown hommand for h2bh"
    end

    exit(true)
  end
  Process.waitpid(child_pid)

  true
end

def hhsh_execute(args)
  return true if args.empty?

  idx = 0
  cmd = args[0]

  return false if cmd == "exit"
  cmd_args = args.drop(1)

  return hhsh_launch(args) unless BUILTIN_STR_HASH[cmd]

  method(BUILTIN_STR_HASH[cmd]).call(*cmd_args)
end

def hhsh_split_line(line)
  return [] if line.empty?

  line.split(" ")
end

def hhsh_read_line
  Readline.readline("hhsh > #{Dir.pwd} >> ", true)
end

def hhsh_loop
  status = true

  while status do
    line = hhsh_read_line();
    args = hhsh_split_line(line);
    status = hhsh_execute(args);
  end
end

hhsh_loop()
exit()
