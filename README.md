# BOINC client in a Docker container

[![](https://images.microbadger.com/badges/version/boinc/client.svg)](https://microbadger.com/images/boinc/client "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/boinc/client.svg)](https://microbadger.com/images/boinc/client "Get your own image badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/boinc/client.svg)
![Docker Stars](https://img.shields.io/docker/stars/boinc/client.svg)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/boinc/client.svg)

The client can be accessed remotely or locally with any BOINC Manager.

**Contents**

## Usage

The following command runs the BOINC client Docker container,

```sh
docker run -d \
  --name boinc \
  --net=host \
  --pid=host \
  -p 34000 \
  -v /opt/appdata/boinc:/var/lib/boinc \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc --gui_rpc_port 34000" \
  boinc/client
```

You can attach a BOINC Manager to the client by launching the BOINC Manager, going to `File > Select computer...`, and entering the IP address of the PC running the Docker container in the "Host name" field (`127.0.0.1` if running locally) as well as the password you set with `BOINC_GUI_RPC_PASSWORD` (here `123`),

![image](https://github.com/BOINC/boinc-client-docker/blob/master/manager_connect.png)

As usual, the client can also be controlled from the command line via the `boinccmd` command. 

From the same computer as the one which is running the Docker container, you can issue commands via,

```sh
docker exec boinc boinccmd <args>
```

From other computers, you should use instead,

```sh
docker run --rm boinc/client boinccmd --host <host>:<rpc_port> --passwd 123 <args>
```

where `<host>` should be the hostname or IP address of the machine running the Docker container. 

You are also free to run `boinccmd` natively if you have it installed, rather than via Docker. 


- Install the `virtualbox-dkms` package on the host. NOTE: The version of the Virtualbox must by identical (major.minor.patch) on the host and the container.
- Run the following command:

```sh
docker run -d \
  --name boinc \
  --device=/dev/vboxdrv:/dev/vboxdrv \
  --net=host \
  --pid=host \
  -p 34000 \
  -v /opt/appdata/boinc:/var/lib/boinc \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_multiple_clients --allow_remote_gui_rpc --gui_rpc_port 34000" \
  -e HOST_USER_ID="123" \
  -e HOST_USER_GID="130" \
  boinc/client:virtualbox
```

## Parameters

When running the client, the following parameters are available (split into two halves, separated by a colon, the left hand side representing the host and the right the container side).

| Parameter | Function |
| :--- | :--- |
| `-e BOINC_GUI_RPC_PASSWORD="123"` | The password what you need to use, when you connect to the BOINC client.  |
| `-e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc"` | The `--allow_remote_gui_rpc` command-line option allows connecting to the client with any IP address. If you don't want that, you can remove this parameter, but you have to use the `-e BOINC_REMOTE_HOST="IP"`. |
| `-v /opt/appdata/boinc:/var/lib/boinc` | The path where you wish BOINC to store its configuration data. |
| `-e BOINC_REMOTE_HOST="IP"` | (Optional) Replace the `IP` with your IP address. In this case you can connect to the client only from this IP. |
| `-e TZ=Europe/London` | (Optional) Specify a time zone. The default is UTC +0. |
| `--pid=host` | (Optional) Share the host's process namespace, basically allowing processes within the container to see all of the processes on the system. Allows boinc to determine nonboinc processes for CPU percentages and exclusive applications. |



## More Info
- How to build it yourself: `docker build -t boinc/client -f Dockerfile.base-ubuntu .`
- Shell access whilst the container is running: `docker exec -it boinc /bin/bash`
- Monitor the logs of the container in realtime: `docker logs -f boinc`
