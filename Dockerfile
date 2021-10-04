FROM ubuntu:18.04

MAINTAINER Roy Zheng "docker@roy.cc"

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    HOME=/app \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    NO_VNC_HOME=/app/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false

COPY ./xfce $HOME
COPY ./scripts $STARTUPDIR

# 安装Tools
RUN set -eux; \
    mkdir -p $HOME; \
    apt-get update; \
    apt-get install -y vim wget net-tools locales bzip2 python-numpy desktop-file-utils; \
    locale-gen en_US.UTF-8; \
# 安装字体
    apt-get install -y ttf-wqy-zenhei; \
# 安装tigervnc和no-vnc
    wget -qO- https://jaist.dl.sourceforge.net/project/tigervnc/stable/1.8.0/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /; \
    mkdir -p $NO_VNC_HOME/utils/websockify; \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME; \
    wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify; \    
    chmod +x -v $NO_VNC_HOME/utils/*.sh; \
    ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html; \
# 安装Chrome
    apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg; \
    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome; \
    echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init; \
# 安装xfce
    apt-get install -y supervisor xfce4 xfce4-terminal xterm; \
# 安装libnss-wrapper
    apt-get install -y libnss-wrapper gettext; \
# 安装百度网盘
    wget -O /tmp/baidudnetdisk.deb http://wppkg.baidupcs.com/issue/netdisk/LinuxGuanjia/3.0.1/baidunetdisk_linux_3.0.1.2.deb; \
    dpkg -i /tmp/baidudnetdisk.deb; \
    rm -f /tmp/baidudnetdisk.deb; \
# 设置文件权限
    find $STARTUPDIR  -name '*.sh' -o -name '*.desktop' | xargs chmod a+x; \
    find $HOME  -name '*.sh' -o -name '*.desktop' | xargs chmod a+x; \
# 清理
    apt-get purge -y pm-utils xscreensaver*; \
    apt-get clean -y;

EXPOSE $VNC_PORT $NO_VNC_PORT
VOLUME ["/app/baidunetdisk", "/app/baidunetdiskdownload"]
WORKDIR $HOME
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
