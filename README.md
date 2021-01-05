# CentOS7イメージ

## Vagrant起動
CentOS7.8を起動する。
```bash
vagrant up
vagrant ssh
```

## プロビジョニング
provision.shを実行して、下記の設定を行う。
* locale設定 (ja_JP.UTF-8)
* タイムゾーン変更 (Asia/Tokyo)
* SELinux無効化

```bash
sudo su
sh /vagrant/provision.sh
```
実行すると再起動のため、ログアウトされてしまうので、再接続する。
```bash
vagrant ssh
```

## CentOSのバージョン確認
```bash
cat /etc/redhat-release
```
※ CentOS7.8のようです

## 依存パッケージ
GuestAdditionsのインストールの前に、CentOSの「カーネル更新」と「依存パッケージ」をインストールします。
```bash
sudo su
yum -y update kernel
yum -y install gcc kernel-devel bzip2
```

## 光学ドライブ(CD-ROM)を追加する
サーバを停止しておく。
```bash
exit
exit
vagrant halt
```

VirtualBoxマネージャから対象の仮想マシンに光学ドライブを追加します。
```
対象イメージの上で右クリック -> 設定 
・ ストレージ -> ＋ (光学ドライブ追加) ->「空のままにする」をクリックして追加する
```

サーバを再起動する。
```bash
vagrant up
vagrant ssh
```

## Guest Additions CD
Virtualboxで起動中のCentOSをクリックして、下記操作をする。  
```
メニューバー -> デバイス -> Guest Additions CD イメージ挿入をクリックする
```

## GuestAdditionsのインストール
ホストとファイルの同期を行いたいのでGuestAdditionsを追加し、vagrantを終了する。
```bash
sudo su
mount -r /dev/cdrom /mnt
/mnt/VBoxLinuxAdditions.run
umount /mnt
exit
exit
vagrant halt
```
## 同期設定
下記設定をVagrantfileに追記して、再起動する。
```bash
vi Vagrantfile
config.vm.synced_folder ".", "/vagrant", type:"virtualbox"

vagrant up --provider virtualbox
```

## クリーンアップ
不要なファイルを削除する。
```bash
vagrant ssh
sudo su
yum clean all
rm -rf /var/log/*
rm -rf /tmp/*
rm -f /root/.bash_history
history -c
shutdown -h now
```

## VagrantのPackageを作成する
サーバを停止して、Package化 ( package.box ) する。
```bash
vagrant halt
vagrant package --base vagrant-centos78_default_******
```

## vagrantのBoxとして登録する
下記コマンドにてBoxに追加して、動作確認してみる。
```bash
vagrant box add local/centos-7.8 package.box
vagrant box list
```

## Vagrant Cloudに登録する
下記クラウドにログインして、 **package.box** を登録する。  
https://app.vagrantup.com/

## 参考サイト
* [vagrantのcentos/7にguest additionsをインストール](https://qiita.com/hermannsw/items/5209ac59d887dd3836ec)
* [Vagrantで共有フォルダの内容がリアルタイム同期されない件](https://qiita.com/sudachi808/items/edc304b3ee6c1436b0fd)

以上

