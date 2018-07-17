# NIG_super_computer
## reference  
1. https://sc2.ddbj.nig.ac.jp/index.php/ja-howtouse
2. https://bi.biopapyrus.jp/os/linux/qsub.html
3. https://sc2.ddbj.nig.ac.jp/images/stories/meetingdoc/20120510/ja/ja_Knowhow-for-entering-jobs-in-UGE-1.pdf
4. https://sc2.ddbj.nig.ac.jp/index.php/index.php/ja-uge-additional#info8
## memo
### qsubの基本
1. 実行したいコマンドをシェルスクリプト内に記述し、qsubコマンドでジョブを投入する。  
例    
#!/bin/sh  
#$ -q small  
#$ -cwd  
path=~/unix15  
bowtie2 -x ${path}/rnaseq/ecoli_genome   
        -U ${path}/rnaseq/test_fastq/ecoli.1.fastq  
        -S ${path}/sge/results/ecoli.sam  
        
注意点として他のマシンに仕事をさせるので、ファイル内のpathはすべて絶対パスで書く。  
#$でオプションを指定。  
(-cwdコマンドを指定したときは相対パスでOK）  
#### qsub option
-S 実行時のシェルを指定  
-l メモリ容量の確保や計算機などの指定   
-pe 利用するプロセッサー  
-t アレイジョブ。互いに独立な複数のジョブを同じ方法で解析したい場合に利用する。  
-N ジョブ名  
-cwd qsubコマンドを実行したディレクトリで始める。  

#### アレイジョブ
オプション #$ -t 1-x:1を加える。  
これは$SGE_TASK_IDに1からxまで一つずつ代入してジョブを走らせるオプションである。  

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

### UGEのジョブ投入数の上限
#### ジョブ投入数の上限
1. 全員で50000ジョブ(実行待ちジョブ合計数が50000ジョブ)
2. 1userで5000ジョブ(実行待ちジョブ合計数が5000ジョブ)
3. アレイジョブはタスク数にかかわらず1ジョブとカウントされるが、75000タスクが上限

#### ジョブの同時実行数上限
qquotaコマンドで確認可能。現状300まで可能

## コマンドまとめ
### login
$ ssh user_name@gw2.ddbj.nig.ac.jp  
$ qlogin  
 
### ノードからのlogout
$ exit  

### gatewayノードからのlogout
$ exit  

### scp
$ scp file_name daiyaohara@gw2.ddbj.nig.ac.jp:/home/daiyaohara/

### vi command memo
空白行を削除
1. :%s/\s*$   で末尾の空白を削除
2. :v/./d　  　ですべての空白行を削除
