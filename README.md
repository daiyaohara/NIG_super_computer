# NIG_super_computer

## コマンドまとめ  
### 公開鍵の登録（アカウント入手後に一度だけ行う、同一アカウントでもPCごとに登録が必要）   
https://sc2.ddbj.nig.ac.jp/index.php/2014-09-17-05-42-33  
  
### login
$ ssh user_name@gw.ddbj.nig.ac.jp  #gateway node ここでJobを投げてはいけない。  
$ qlogin  #こっちに入ってからqsubコマンドでJobを投げる。  
 
### ノードからのlogout
$ exit  

### gatewayノードからのlogout
$ exit  #logoutしても投入中のジョブは消えない。

### scp (local -> server)
$ scp file_name user_name@gw2.ddbj.nig.ac.jp:/home/user_name/

### sftp (server -> local)
$ sftp user_name@gw2.ddbj.nig.ac.jp  
$ > get PATH

### ジョブを投げる
$ qsub -l d_rt=192:00:00 -l s_rt=192:00:00 test.sh   #3日以上ジョブを実行したいとき  
$ qsub -l s_vmem=512G -l mem_req=512G -l medium FILE_NAME  
#メモリ容量を指定して投げないとmedium nodeでもMemory Errorが出る。デフォルトは4GB  
各ノードのオプション  
-l fat #fat node  
-l medium #medium node  
-l month #month_hdd.q  
-l gpu #month_gpu.q  
-l short #short.q  
-l ssh #month_ssh.q (phase2のみ）


### ジョブの確認
$ qstat  #自分のジョブの状況を確認する  
$ qstat -j job_ID #job_ID のジョブについて状況を確認する。  
$ qstat -g c #全体の状況を確認する  

### ジョブを終了させる
$ qdel job_ID #job_IDのジョブを終了させる。  
$ qdel -u user_name #自分のジョブをすべて終了させる。  

### vi command memo
空白行を削除
1. :%s/\s*$   で末尾の空白を削除
2. :v/./d　  　ですべての空白行を削除

## 環境設定
### editorの環境構築 (Remote VScode)
1. Visual Studio codeでRemote VScodeをインストール -> reload  
2. VScodeのfile -> preference -> setting において  
{  
    "remote.onstartup": true  
}  
と設定しておく。  
3. host 側にて~/.ssh/config を以下のように設定  

```:~/.ssh/config
HOST gw2.ddbj.nig.ac.jp  
    ForwardAgent yes  
    RemoteForward 52698 localhost:52698  
```

4. サーバー側にてrmateをダウンロードする  
$ wget -O /home/user_name/rmate https://raw.github.com/aurora/rmate/master/rmate  
$ chmod +x rmate  
5. gateway_nodeにおいて  
$ bash rmate ファイル名   
でVS code使用可能。qlogin後では使用不可。

## python環境設定
### Miniconda3
#### install
$ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  
$ bash Miniconda3-latest-Linux-x86_64.sh  
$ cd miniconda3/bin/ #ここに移動して仮想環境を作らないとエラーがでる  
$ ./conda config --add channels defaults  
$ ./conda config --add channels conda-forge  
$ ./conda config --add channels bioconda  
#### 仮想環境構築
$ ./conda create -n ENV_NAME python=3.5  #/home/user_name/miniconda3/envs/ENV_NAMEに仮想環境が作られる  
$ cd miniconda3/bin  
$ source activate ENV_NAME #有効化  
$ ./conda install -n ENV_NAME pip  #pipをENV_NAMEにインストール  
$ which pip #~/miniconda3/envs/ENV_NAME/bin/pip  
$ ./conda list -n ENV_NAME #インストールされているパッケージの確認  
$ source deactivate ENV_NAME #無効化  

### virtualenv
1. virtualenvはデフォルトでインストールされている。  
2. virtualenv pyenv1  
3. source pyenv1/bin/activate #有効化  
4. deavtivate #無効化  

### bhtsne
https://github.com/lvdmaaten/bhtsne よりリポジトリをダウンロード
g++ sptree.cpp tsne.cpp tsne_main.cpp -o bh_tsne -O2　#bh_tsneを有効化

## UGEの基本
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

## 遺伝研スーパーコンピューターに関して
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

## reference  
1. https://sc2.ddbj.nig.ac.jp/index.php/ja-howtouse
2. https://bi.biopapyrus.jp/os/linux/qsub.html
3. https://sc2.ddbj.nig.ac.jp/images/stories/meetingdoc/20120510/ja/ja_Knowhow-for-entering-jobs-in-UGE-1.pdf
4. https://sc2.ddbj.nig.ac.jp/index.php/index.php/ja-uge-additional#info8

## memo
### 用語
OSS オープンソースソフトウェア

