# cloudflare-ddns-script
cloudflare ddns script
# 该脚本支持主流linux系统，支持同时更新IPV4和IPV6地址到cloudflare云端解析。
# 脚本顶部需要填写你的cloudflare api key、区域ID、cloudflare邮箱、域名等变量。
# 脚本包含大量注释，方便小白理解脚本每一步的运行原理。
# 脚本会打印日志到屏幕，所有动作一目了然。

# 使用方法：
```
crontab -e

#开机等待60秒以后自动运行DDNS脚本
@reboot sleep 60 && /root/cf-ddns.sh >/dev/null 2>&1

#每隔5分钟运行1次DDNS脚本
*/5 * * * * /root/cf-ddns.sh >/dev/null 2>&1
```
