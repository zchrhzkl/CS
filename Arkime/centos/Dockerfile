ARG CENTOS_VERSION=7
FROM centos:$CENTOS_VERSION

# Install dependencies that are needed, but not set in the arkime.deb file
RUN yum update -y && \
    yum install -yq curl libmagic-dev wget logrotate epel-release yum-plugin-copr gcc libpcap-devel pcre-devel libyaml-devel file-devel zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make libnetfilter_queue devel lua-devel PyYAML libmaxminddb-devel rustc cargo lz4-devel libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config libnspr4-dev libnss3-dev liblz4-dev rustc cargo python-pip python3-distutils libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0 perl-libwww-perl perl-JSON ethtool perl-LWP-Protocol-https

# Declare args
ARG ARKIME_VERSION=3.4.2
ARG CENTOS_VERSION
ARG ARKIME_RPM_PACKAGE="arkime-"$ARKIME_VERSION"-1.x86_64.rpm"

# Declare envs vars for each arg
ENV ARKIME_VERSION $ARKIME_VERSION
ENV ES_HOST "192.168.100.5"
ENV ES_PORT 9200
ENV ARKIME_INTERFACE "eth0"
ENV ARKIME_ADMIN_PASSWORD "admin"
ENV ARKIME_HOSTNAME "localhost"
ENV ARKIMEDIR "/opt/arkime"
ENV CAPTURE "off"
ENV VIEWER "on"

# Install Arkime
RUN mkdir -p /data && \
    cd /data && \
    curl -C - -O "https://s3.amazonaws.com/files.molo.ch/builds/centos-"$CENTOS_VERSION"/"$ARKIME_RPM_PACKAGE && \
    rpm -i $ARKIME_RPM_PACKAGE || true && \
    yum install -y arkime && \
    mv $ARKIMEDIR/etc /data/config && \
    ln -s /data/config $ARKIMEDIR/etc && \
    ln -s /data/logs $ARKIMEDIR/logs && \
    ln -s /data/pcap $ARKIMEDIR/raw
# clean up
RUN rm -rf /tmp/* /var/tmp/* /var/cache/* && \
    rm /data/$ARKIME_RPM_PACKAGE

# add scripts
ADD ./scripts /data/
RUN chmod 755 /data/*.sh

VOLUME ["/data/pcap", "/data/config", "/data/logs"]
EXPOSE 8005
WORKDIR $ARKIMEDIR

ENTRYPOINT ["/data/startarkime.sh"]
