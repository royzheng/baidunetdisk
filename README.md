# 百度网盘 ubuntu xfce 镜像

- ubuntu 系统+xfce 桌面 + vnc
- 百度官方 linux 客户端

## VOLUME 说明

- /config 是百度网盘客户端的配置文件
- /downloads 是百度网盘客户端默认的下载路径（即运行客户端的时候不用去改变默认路径)

## VNC 说明

- 环境变量 VNC_PW 是 vnc 的访问密码(不传入则为 vncpassword)
- VNC 的默认端口是 5901
- VNC HTTP 的默认端口是 6901

## 如何运行

```
docker pull royzheng/baidunetdisk
docker run -d -v YOUR_CONFIG_PATH:/config -v YOUR_DOWNLOAD_PATH:/downloads -e VNC_PW=YOUR_PASSWORD -p YOUR_PORT:5901 -p YOUR_HTTP_PORT:6901 royzheng/baidunetdisk:latest
```
