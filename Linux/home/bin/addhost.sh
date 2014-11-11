#
# add host to /etc/hosts
# 

DIR=$(cd $(dirname "$0"); pwd)
cd $DIR

. ./config.sh

notfile_die ./hosts

awk '{v=$1; if(v!= "") print $1;}' /etc/hosts > ./temp.txt

ips=""

while read LINE; do
ips=${ips}$LINE" "
done < ./temp.txt 

lines=""

while read LINE; do
  ip=`echo $LINE | awk '{print $1;}'`
  find_it="false"
  for oldip in $ips; do
    [ "$ip" == "$oldip" ] && {
      find_it="true"
      break
    }
  done
  [ "$find_it" == "false" ] && {
    lines=${lines}${LINE}"\n";
  }
done < ./hosts

echo "add hosts:"
echo -e $lines

echo -n -e $lines | sudo tee -a /etc/hosts > /dev/null
