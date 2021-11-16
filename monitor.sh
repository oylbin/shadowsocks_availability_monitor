function check_param {
    for i in $@
    do
        if [[ ! "${!i}" ]]
        then
            echo "need env param: $i"
            exit 1
        fi
    done
    return 0
}

check_param SS_SERVER SS_PORT SS_METHOD SS_PASSWORD

if [ "$SS_OBFS_OPTS" = "" ] ; then
    docker run --rm --name ss_monitor -d oylbin/ss_with_obfs:latest ss-tunnel \
        -s $SS_SERVER -p $SS_PORT -m "$SS_METHOD" -k "$SS_PASSWORD" \
        -b 0.0.0.0 -l 9527 -L www.google.com:80 -v
else
    docker run --rm --name ss_monitor -d oylbin/ss_with_obfs:latest ss-tunnel \
        -s $SS_SERVER -p $SS_PORT -m "$SS_METHOD" -k "$SS_PASSWORD" \
        --plugin obfs-local --plugin-opts "$SS_OBFS_OPTS" \
        -b 0.0.0.0 -l 9527 -L www.google.com:80 -v
fi

docker exec ss_monitor bash -c \
    'cat <(echo -e "HEAD / HTTP/1.0\nHost: www.google.com\n\n") <(sleep 5) | nc -w 10 127.0.0.1 9527' > /tmp/ss_monitor.log
docker stop ss_monitor

line=$(cat /tmp/ss_monitor.log | tr -d '\r' | head -n 1)

if [ "$line" = "HTTP/1.0 200 OK" ] ; then
    echo "server available"
    exit 0
else
    echo "server unavailable"
    exit 1
fi