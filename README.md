# hhsh

ruby製のshellです。

#### usage

hhshの実行ファイルにpathを通します。
```
fish
$ set pwd (pwd)
$ set -x PATH/bin pwd $PATH

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
