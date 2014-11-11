# 磁盘

## 分区  

命令：

    fdisk

查看当前Linux分区情况

    fdisk -l



##  格式化

命令：
    
    mkfs

格式：

    mkfs –t 文件系统类型 分区设备

参数：

    -t : 给定档案系统的型式，Linux 的预设值为 ext2
    -c : 在制做档案系统前，检查该partition 是否有坏轨
    -V : 详细显示模式
    
    mkfs -V -t ext4 -c /dev/sdb1

    set -e
    umount /dev/sdj1;mkfs -V -t ext3 /dev/sdj1;mount /dev/sdj1 /home9;    
    umount /dev/sdk1;mkfs -V -t ext3 /dev/sdk1;mount /dev/sdk1 /home10;

umount /dev/sdv1; mkfs -t ext3 /dev/sdv1; mount /dev/sdv1 /home21; umount /dev/sdw1; mkfs -t ext3 /dev/sdw1; mount /dev/sdw1 /home22; umount /dev/sdx1; mkfs -t ext3 /dev/sdx1; mount /dev/sdx1 /home23;