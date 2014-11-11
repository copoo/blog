#!/bin/bash
#自动格式化超过2T的磁盘,目前支持将磁盘分成一个区,支持ext3和ext4
#警告：请在新上服务器使用该脚本，在线服务器请备份重要数据。由于没有人工确认环节，如果格错了磁盘丢了数据，你就自己哭吧!
#writed by liuys 2014-05-20

diskSizeNum=2197198755840  #大于2T的磁盘
partedBin="/sbin/parted"
automount=0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
log=$DIR/log.log
fstabtmp=$DIR/fstab.log
mounttmp=$DIR/mount.log
tmplog=./$$_tmp.log
echo "" > $log
echo "" > $fstabtmp
echo "" > $mounttmp

tmp_fifofile="./$$.fifo" #新建一个fifo类型的文件
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile #将fd6指向fifo类型
rm -rf $tmp_fifofile

print_help() {
	echo -e "\t	可用参数说明:\n
	\t\033[32m[必填]\033[0m\n
	\t    -t ext3|ext4\n
	\t\033[32m[可选]\033[0m\n
	\t    -m 格式完后自动挂载并写入fstab\n
	\t如：sh ${BASH_SOURCE[0]} -t ext4 -m\n"

}

function a_sub()
{
    sleep 2  #定义格式化命令后多久开始检查
}

diskFormat(){
	diskN=$1
	$partedBin $diskN --script mklabel gpt
	$partedBin $diskN --script "mkpart primary 0% 100%"
	#$partedBin $diskN --script print
	disk=$diskN
	offset=97
	charater=`echo "$disk"| sed 's/\(.*\)\(.\)$/\2/'`
	hex=`printf "%d" "'$charater'"`  #注意：$1前有个单引号
	dirNum=`echo "$hex-$offset"|bc`
	echo -e -n "\n\033[31m [$(date +%F_%T)] 开始格式化磁盘：${disk}1\033[0m\n" |tee -ai $log
	$formatbin ${disk}1
	#echo -e -n "\n[$(date +%F_%T)] 创建磁盘标签: e2label ${disk}1  /home$dirNum \n" |tee -ai $log
	#e2label ${disk}1  /home$dirNum
	echo -e -n "\n\033[32m[$(date +%F_%T)] $formatbin $disk 格式化完成! \033[0m\n" |tee -ai $log
	echo  -e -n "\n[$(date +%F_%T)] 创建目录 mkdir /home$dirNum \n" |tee -ai $log
	test -d /home$dirNum || mkdir /home$dirNum
	#UUID=`blkid | grep "${disk}1" | awk -F\" '{print $2}'`
	#echo "UUID=${UUID}            /home$dirNum                 $formatType    defaults        0 0" >> $fstabtmp
	echo "${disk}1            /home$dirNum                 $formatType    defaults        0 0" >> $fstabtmp
	echo "mount ${disk}1            /home$dirNum" >> $mounttmp

}

#格式化完成后处理 1.写入fstab；2.挂载
domount(){
	cat $mounttmp | sort -k2 > $tmplog
	cat $tmplog > $mounttmp 
	cat $fstabtmp | sort -k1 > $tmplog
	cat $tmplog > $fstabtmp
	if [ $automount -eq 1 ];then
		echo -e -n "\n[$(date +%F_%T)] 执行挂载所有磁盘\n"  |tee -ai $log
		sh $mounttmp
		cat $fstabtmp >> /etc/fstab
	fi	
	echo -e -n "\n\n\033[32m[$(date +%F_%T)] 格式化完成!\033[0m\n\n\033[34m 本次格式化的磁盘及挂载对应目录为：\033[0m\n"  |tee -ai $log
	cat $mounttmp|awk '{print $2"\t"$3}' |tee -ai $log
	echo -e -n "\n\033[32m更多信息：\033[0m\n日志：$log\nmount命令：$mounttmp\n可写入fstab：$fstabtmp\n\n"
}
diskSerachAndCheck(){
	#查找所有磁盘
	fdisk -l|egrep "Disk /dev/" | egrep -v "/dev/sda" > $tmplog
	diskAllAndSize=(`cat $tmplog|awk '{print $2"|"$(NF-1)}'|sed  's/://g'|tr -d '\n'|sed 's/\/dev/ \/dev/g'`)

	#进程数等于要格式硬盘数量
	threadNum=${#diskAllAndSize[@]}
	for ((i=0;i<$threadNum;i++));do
		echo 
	done >&6
	#如果磁盘大于2T，并且还没分区，则进行分区和格式化操作
	for((i=0;i<${#diskAllAndSize[@]};i++)) do 
		read -u6
		{	
			diskAndSize=${diskAllAndSize[$i]};
			diskname=$(echo $diskAndSize|cut -d '|' -f1)
			disksize=$(echo $diskAndSize|cut -d '|' -f2)
			if [ $disksize -gt $diskSizeNum ] && [ ` cat /etc/mtab|egrep -c $diskname` -eq 0 ];then
				mkdir /mnt/test1
				mount ${diskname}1  /mnt/test1
				if [ $? != 0 ] || [ `fdisk -l|egrep -c "${diskname}1"` == 0 ];then
					echo -e -n "\n[$(date +%F_%T)] 正在处理：$diskname 磁盘大小： $disksize" |tee -ai $log
					diskFormat $diskname
				
					a_sub && {
						#检查格式化完后的磁盘是否可以挂载并使用
						echo -e -n "\n[$(date +%F_%T)] ${diskname}1 check"
						mkdir /mnt/test
						mount ${diskname}1  /mnt/test
						touch /mnt/test/$$
					} || {
						echo -e -n "\n\033[41;37m[$(date +%F_%T)] ${diskname}1 error\033[0m\n"
					}
					umount /mnt/test
				else
					echo -e -n "\n\033[34m[$(date +%F_%T)] 忽略磁盘：${diskname}1 已格式好，未挂载\033[0m\n" |tee -ai $log
				fi
				umount /mnt/test1
			else
				echo -e -n "\n\033[34m[$(date +%F_%T)] 忽略磁盘：$diskname 磁盘大小： $disksize\033[0m\n" |tee -ai $log
			fi
			echo >&6
		
		} &
	done
	wait
	exec 6>&-
	
	domount
	rm -f  $tmplog
}

diskSerachAndDelectPartion(){
	#查找所有磁盘
	fdisk -l|egrep "Disk /dev/" | egrep -v "/dev/sda" > /root/test
	cp /etc/fstab /root/fstab_20140728_1
	disk_find=(`cat /root/test | awk '{print $2}' |awk -F: '{print $1}'`)
	for((i=0;i<${#disk_find[@]};i++)) 
	do 
		disk_find_name=${disk_find[i]}
		umount ${disk_find_name}1
		/sbin/parted --script ${disk_find_name} "rm 1" 
		
	done
	
}


#启动 获取格式文件系统类型
while test -n "$1";do
	case "$1" in
		--help|-h)
			print_help                     
			exit   1
			;;
		--type|-t)  
			formatType=$2
			shift
			;;
		-m|-M)
			automount=1
			;;
		*)
			echo -e "\n\t\033[31m参数错误: $1\033[0m\n"
			print_help
			exit  1
			;;
	esac
	shift
done

if [ -z $formatType ];then
        echo -e "\n【INFO】:  请指定用参数 --type|-t ext3|ext4 为磁盘指定文件系统\n"
	print_help
        exit  1
fi
case $formatType in 
		ext3)
			formatbin="/sbin/mkfs.ext3"
			;;
		ext4)
			formatbin="/sbin/mkfs.ext4"
			;;
		*)
			echo -e "\n\t\033[31m文件系统未识别，暂时支持ext3和ext4 \033[0m\n"
			print_help
			exit
		;;
esac
diskSerachAndDelectPartion
diskSerachAndCheck