# hhsh

ruby製のshellです。

#### usage

hhshの実行ファイルにpathを通します。
```
fish
$ set pwd (pwd)
$ set -x PATH $PWD/bin $PATH

bash
$ pwd=$(pwd)
$ export PATH="$pwd/bin:$PATH"
```

#### hhsh can

* execute cd, ls, pwd shell commands.
* file execution.

(2019/12/25)

#### 現在実装中の機能
* 履歴の部分で、スペースを入れないようにする
* cdのエラーハンドリング
* オプションを受け取れるようにする
* バッククオートで改行できない
* 実装コマンドの管理をどこかに移す


# 実装について

#### spawnとexecの違いについて

spawnは子プロセスを作成してそこでコマンドを実行する。
execは現在のプロセスを上書きして実行する

spawnはコマンド実行後もそのプロセスは残るが、execは実行した時点で終了コードを返してexitする。

終了コードを返すと言う点でこっちを採用した

#### reopenについて
https://docs.ruby-lang.org/ja/latest/method/IO/i/reopen.html

IOオブジェクトのreopenメソッドを使用することで、sprawnメソッドのオプションなどで行われる挙動のようなリダイレクトではなく、ファイルディスクリプタ自体を置き換える

ファイルディスクリプタ自体はただのファイルへの参照のキーである。

```sample.rb
r,w = fork()

p $stdin.fileno
p r.fileno

$stdin.reopen(r)
p $stdin.fileno

#=> 0
#=> 10
#=> 0
```

標準入出力など、ファイルディスクリプタ0,1,2に割り当てられるバッファ領域は引き継がれないので、必ずforkをした後にパイプ処理をしたい場合は書き換える。

これは考えてみれば当たり前の話で、

シェルなどでプロセスをあforkした場合に共通のバッファ領域が0,1,2に割り当てられていた場合、

親子で同じ入力をリアルタイムで受け取ることになってしまう。

rubyのcloseはプロセス自体がもつファイルディスクリプタ自体への変更をしないっぽい？
あくまでrubyのプログラムからファイルディスクリプタへのアクセスを拒絶するだけ？
