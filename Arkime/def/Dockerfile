FROM centos:7

RUN yum update -y && \
    yum install -y -q wget epel-release yum-plugin-copr gcc libpcap-devel pcre-devel libyaml-devel file-devel zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make libnetfilter_queue devel lua-devel PyYAML libmaxminddb-devel rustc cargo lz4-devel libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config libnspr4-dev libnss3-dev liblz4-dev rustc cargo python-pip python3-distutils libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0 perl-libwww-perl perl-JSON ethtool perl-LWP-Protocol-https

RUN wget https://s3.amazonaws.com/files.molo.ch/builds/centos-7/arkime-3.4.2-1.x86_64.rpm && \
    rpm -i arkime-3.4.2-1.x86_64.rpm && \
    yum install -y -q arkime  \
    service start cron.service \
    service start arkimecapture.service && \
    service start arkimeviewer.service
