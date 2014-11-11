wget -r -c -H -t 2 --waitretry=1 -T 5 --connect-timeout=5 --read-timeout=10 --max-redirect=5 \
  -D ${1:-"9game.cn"} \
  -X "member,ad,login" \
  -U "Mozilla/5.0 (Linux; U; Android 4.0.4; zh-CN; XT928 Build/6.7.2_GC-158-DNRCG-10) AppleWebKit/534.31 (KHTML, like Gecko) UCBrowser/9.1.0.297 U3/0.8.0 Mobile Safari/534.31" \
  --reject="jpg,jpeg,png,gif,flv,mp3,mp4,txt,apk" \
  --follow-tags="a" \
  --no-check-certificate \
  -e robots=off \
  -P ./data \
  -o ./wget.log \
  ${2:-"http://a.9game.cn/"}
 
