#!/bin/sh
# 脚本调试开关,默认请保持注释,当遇到错误时可去掉#注释,方便排查问题
#set -x

# 填写ipv6只更新ipv6地址,填写ipv4只更新ipv4地址,填写both则同时更新ipv4和ipv6地址
IP_TYPE="both"

# 设置需要更新的域名,需要在cloudflare已经添加了该域名
DOMAIN="pve.yourname.cn"

# 获取本地IPV4地址的接口链接
IPV4_URL="https://4.ipw.cn"

# 获取本地IPV6地址的接口链接
IPV6_URL="https://6.ipw.cn"

# 填写Cloudflare账户的zone id
ZONE_ID="your zone id"

# 填写cloudflare账户的全局api key
API_KEY="your api key"

# 填写cloudflare账户邮箱地址
API_EMAIL="your email"

# 填写ttl时间秒数,默认120秒,一般不需要修改
TTL="120"

# 设置时间戳格式
LOG_TIME="$(date "+%Y-%m-%d %H:%M:%S")"

# 开始执行脚本
echo "${LOG_TIME} - 开始执行脚本"

# 检测需要更新的记录类型
if [ "$IP_TYPE" = "ipv4" ] || [ "$IP_TYPE" = "both" ]; then
    IPV4=$(curl -4 -s ${IPV4_URL} | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
    echo "${LOG_TIME} - 获取本地IPV4地址：${IPV4}"

# 获取当前Cloudflare记录的IPV4地址
    CURRENT_IPV4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${DOMAIN}" \
        -H "X-Auth-Email: ${API_EMAIL}" \
        -H "X-Auth-Key: ${API_KEY}" \
        -H "Content-Type: application/json" | grep -Po '(?<="content":")[^"]*')
        echo "${LOG_TIME} - 获取云端IPV4地址：${CURRENT_IPV4}"

# 比较本地IPV4地址和Cloudflare记录的IPV4地址，如果不同，则更新记录
    if [ "$CURRENT_IPV4" != "$IPV4" ]; then
        echo "${LOG_TIME} - 本地IPV4地址与云端不同，需要更新"
        RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${DOMAIN}" \
            -H "X-Auth-Email: ${API_EMAIL}" \
            -H "X-Auth-Key: ${API_KEY}" \
            -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*')" \
                -H "X-Auth-Email: ${API_EMAIL}" \
                -H "X-Auth-Key: ${API_KEY}" \
                -H "Content-Type: application/json" \
                --data '{"type":"A","name":"'${DOMAIN}'","content":"'${IPV4}'","ttl":"'${TTL}'"}')
        echo "${LOG_TIME} - 云端IPV4地址更新成功：${RESPONSE}"
    else
        echo "${LOG_TIME} - 本地IPV4地址与云端相同，不需要更新"
    fi
fi

# 检测需要更新的记录类型
if [ "$IP_TYPE" = "ipv6" ] || [ "$IP_TYPE" = "both" ]; then
    IPV6=$(curl -6 -s ${IPV6_URL} | grep -oE '[a-f0-9:]+:[a-f0-9:]+:+[a-f0-9]+')
    echo "${LOG_TIME} - 获取本地IPV6地址：${IPV6}"

# 获取当前Cloudflare记录的IPV6地址
    CURRENT_IPV6=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=AAAA&name=${DOMAIN}" \
        -H "X-Auth-Email: ${API_EMAIL}" \
        -H "X-Auth-Key: ${API_KEY}" \
        -H "Content-Type: application/json" | grep -Po '(?<="content":")[^"]*')
        echo "${LOG_TIME} - 获取云端IPV6地址：${CURRENT_IPV6}"

# 比较本地IPV6地址和Cloudflare记录的IPV6地址，如果不同，则更新记录
    if [ "$CURRENT_IPV6" != "$IPV6" ]; then
        echo "${LOG_TIME} - 本地IPV6地址与云端不同，需要更新"
        RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=AAAA&name=${DOMAIN}" \
            -H "X-Auth-Email: ${API_EMAIL}" \
            -H "X-Auth-Key: ${API_KEY}" \
            -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*')" \
                -H "X-Auth-Email: ${API_EMAIL}" \
                -H "X-Auth-Key: ${API_KEY}" \
                -H "Content-Type: application/json" \
                --data '{"type":"AAAA","name":"'${DOMAIN}'","content":"'${IPV6}'","ttl":"'${TTL}'"}')
        echo "${LOG_TIME} - 云端IPV6地址更新成功：${RESPONSE}"
    else
        echo "${LOG_TIME} - 本地IPV6地址与云端相同，不需要更新"
    fi
fi

# 脚本执行完成
echo "${LOG_TIME} - 脚本执行完成"
