# frozen_string_literal: true

# 実際のコマンドを書いていくためのモジュール
module Hhsh
  module Command
    def hhsh_cd(dir = "./")
      if dir == "~"
        Dir.chdir(Dir.home)
        return true
      end

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
  end
end
