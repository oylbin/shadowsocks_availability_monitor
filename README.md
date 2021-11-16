# shadowsocks_availability_monitor

check shadowsocks server availability at client side.

## Usage

Run the following command in a linux server with docker installed:

    export SS_SERVER=...
    export SS_PORT=...
    export SS_METHOD=...
    export SS_PASSWORD=...
    bash monitor.sh

If your shadowsocks server is available, the script will print `server available` and exit with status 0.

Current script use a docker images with shadowsocks-libev v3.1.3 and simple-obfs v0.0.5 which is build from the [Dockerfile](./Dockerfile).
If you use different versions of shadowsocks server, you can modify the Dockerfile and build your own docker image, and then change the docker image name in monitor.sh from `oylbin/ss_with_obfs:latest` to your image name.