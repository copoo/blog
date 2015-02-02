#
proc_numb=`ps -ef|grep ResourceM |grep -v grep|sed -e 's:^.*/process/\(.*\)-yarn-RESOURCEMANAGER.*:\1:'`
proc_work="/var/run/cloudera-scm-agent/process/${proc_numb}-yarn-RESOURCEMANAGER"
sche_file="$proc_work/fair-scheduler.xml"

m=${1:-"small"}

#max_run=${1:-"7"}
#max_mem=${2:-"23792"}
if [[ "$m" == "big" ]]; then
  max_run="15"
  max_mem="70000"
else 
  max_run="7"
  max_mem="23792"
fi

sudo sed -i "/queue.*uaewa/{n;n;s:[0-9]\\+:${max_run}:;n;s:[0-9]\\+:${max_mem}:;n;n;n;s:[0-9]\\+:${max_run}:;}" $sche_file 

sudo -u yarn yarn rmadmin -refreshQueues

