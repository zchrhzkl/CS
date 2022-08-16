#!/bin/bash

echo "Giving ES time to start..."
echo $ES_HOST
echo $ES_PORT
#curl -k "https://elastic:Sovereign78Z@$ES_HOST:$ES_PORT/_cluster/health?wait_for_status=green"
#until curl -k "https://elastic:Sovereign78Z@$192.168.100.5:9200/_cluster/health?wait_for_status=green" > /dev/null 2>&1
#do
#    echo "Waiting for ES to start"
#    sleep 1
#done
#echo
#echo "ES started..."

# set runtime environment variables
export ARKIME_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w32 | head -n1)  # random password
export ARKIME_LOCALELASTICSEARCH=no
export ARKIME_ELASTICSEARCH="https://"$ES_HOST":"$ES_PORT

if [ ! -f $ARKIMEDIR/etc/.initialized ]; then
    echo $ARKIME_LOCALELASTICSEARCH | $ARKIMEDIR/bin/Configure
    echo INIT | $ARKIMEDIR/db/db.pl https://$ES_HOST:$ES_PORT init
    $ARKIMEDIR/bin/arkime_add_user.sh admin "Admin User" $ARKIME_ADMIN_PASSWORD --admin
    echo $ARKIME_VERSION > $ARKIMEDIR/etc/.initialized
else
    # possible update
    read old_ver < $ARKIMEDIR/etc/.initialized
    # detect the newer version
    newer_ver=`echo -e "$old_ver\n$ARKIME_VERSION" | sort -rV | head -n 1`
    # the old version should not be the same as the newer version
    # otherwise -> upgrade
    if [ "$old_ver" != "$newer_ver" ]; then
        echo "Upgrading ES database..."
        echo $ARKIME_LOCALELASTICSEARCH | $ARKIMEDIR/bin/Configure
        echo UPGRADE | $ARKIMEDIR/db/db.pl https://$ES_HOST:$ES_PORT upgrade
        echo $ARKIME_VERSION > $ARKIMEDIR/etc/.initialized
    fi
fi

# start cron daemon for logrotate
service cron start

if [ "$CAPTURE" = "on" ]
then
    echo "Launch capture..."
    if [ "$VIEWER" = "on" ]
    then
        # Background execution
        exec $ARKIMEDIR/bin/capture --config $ARKIMEDIR/etc/config.ini --host $ARKIME_HOSTNAME >> $ARKIMEDIR/logs/capture.log 2>&1 &
    else
        # If only capture, foreground execution
        exec $ARKIMEDIR/bin/capture --config $ARKIMEDIR/etc/config.ini --host $ARKIME_HOSTNAME >> $ARKIMEDIR/logs/capture.log 2>&1
    fi
fi

echo "Look at log files for errors"
echo "  /data/logs/viewer.log"
echo "  /data/logs/capture.log"
echo "Visit http://127.0.0.1:8005 with your favorite browser."
echo "  user: admin"
echo "  password: $ARKIME_ADMIN_PASSWORD"

if [ "$VIEWER" = "on" ]
then
    echo "Launch viewer..."
    pushd $ARKIMEDIR/viewer
    exec $ARKIMEDIR/bin/node $ARKIMEDIR/viewer/viewer.js -c $ARKIMEDIR/etc/config.ini --host $ARKIME_HOSTNAME >> $ARKIMEDIR/logs/viewer.log 2>&1
    popd
fi

