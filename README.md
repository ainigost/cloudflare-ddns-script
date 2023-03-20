# cloudflare-ddns-script

### 该脚本支持主流linux系统，支持同时更新IPV4和IPV6地址到cloudflare云端解析。
### 脚本顶部需要填写你的cloudflare api key、区域ID、cloudflare邮箱、域名等变量。
### 脚本包含大量注释，方便小白理解脚本每一步的运行原理。
### 脚本会打印日志到屏幕，所有动作一目了然。

# 使用方法：
```
cd /root
wget https://raw.githubusercontent.com/ainigost/cloudflare-ddns-script/main/cf-ddns.sh
#注意：下载后需要编辑该脚本的内置变量，填写你自己的api key、邮箱、域名等设置。
chmod +x cf-ddns.sh
./cf-ddns.sh
```

# 添加开机自启动或者设置定时任务
```
crontab -e

#开机等待60秒以后自动运行DDNS脚本
@reboot sleep 60 && /root/cf-ddns.sh >/dev/null 2>&1

#每隔5分钟运行1次DDNS脚本
*/5 * * * * /root/cf-ddns.sh >/dev/null 2>&1
```
