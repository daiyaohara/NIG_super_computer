# NIG_super_computer
## reference  
https://sc2.ddbj.nig.ac.jp/index.php/ja-howtouse

## memo
### 各ノードの特徴について
#### thin node
1. 1CPUあたりの処理能力が最も高性能
2. メモリ64GB
3. 16 core
4. SSD+GPU, GPU搭載のノードも存在する。
#### Medium node 
1. 1jobあたりの要求メモリ量が64GB-2TBの間の処理であればこのノードを利用する
2. 80 core
#### Fat node
1. 1jobあたりの要求メモリ量が64GB-2TBの間の処理であればこのノードを利用する
2. 768 core

### ファイルシステムに関して
1. 数GBの少数ファイルに高速アクセスできるが、多数のファイル操作には弱い
2. 数GB以上のファイルを配置するときや、数MBのファイルを数百個配置するときはストライプカウントを変更すると早くなる。
   $ lfs setstripe -c ストライプ数 対象ディレクトリ
3. 数KBのファイルを操作するときはストライプ数をあげると逆に負荷が上がる。

## login
$ ssh user_name@gw2.ddbj.nig.ac.jp  
$ qlogin  

## ノードからのlogout
$ exit  

## gatewayノードからのlogout
$ exit  

## scp
$ scp file_name daiyaohara@gw2.ddbj.nig.ac.jp:/home/daiyaohara/

## vi command memo
空白行を削除
1. :%s/\s*$   で末尾の空白を削除
2. :v/./d　  　ですべての空白行を削除
