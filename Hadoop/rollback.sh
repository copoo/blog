# 2014-11-26 回滚 hdfs 升级的数据

set -e

rollback () {
  local h=$1

  echo -n "= $h = "  

  cd /home$h/hadoop/dfs/current/
  cp ./VERSION ./VERSION.56
  sed -i -e "s:56$:55:" ./VERSION
  cd ./BP-277597707-10.16.135.145-1406551222293
  mv ./current ./current.56
  mv ./previous ./current

  echo -n " Check " 
   
  [[ -d ./current.56 ]] && 
  [[ -d ./current ]] &&
  cd .. &&
  [[ -f ./VERSION.56 ]] &&
  [[ -f ./VERSION ]] &&
  local line=`tail -n 1 ./VERSION 2>&1` &&
  [[ "$line" == "layoutVersion=-55" ]] && 
  echo "OK" || echo "FAILED"
}

for i in `seq 1 10`; do
  rollback $i
done

