# NIG_super_computer
## reference  
ssh daiyaohara@gw2.ddbj.nig.ac.jp

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
