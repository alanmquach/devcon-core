# `devcon-core` - Development Container Core Image
A (relatively) slim, opinionated container used as an easily reproducible development environment.

## Contains (but not limited to)
* `openssh-server`
* [`mosh`](https://mosh.org/)
* `tmux`
* `git`
* `vim`
* `ag`

## Usage
```
docker run -d \
	-p XXXXX:22 \
	-p 60000-60010:60000-60010/udp \
	alanmquach/devcon-wm:latest \
  /tmp/bootstrap.sh "developer" "public_key"
```
This will start the container with the default command `/usr/sbin/sshd -D` to run sshd as a daemon.
* `-p XXXXX:22` binds the host's port `XXXXX` to the container's SSH port (22)
* `-p 60000-60010:60000-60010/udp` binds the host's `mosh` ports to the container's

[`/tmp/bootstrap.sh`](https://github.com/alanmquach/devcon-core/blob/master/bootstrap.sh)
This script handles user creation and authorizing public keys (`~/.ssh/authorized_keys`) for convenience:
```
/tmp/bootstrap.sh "your_username_here" "your_public_key_here"
```
The user is created with `--disabled-password` by default.

This is usually enough to get the very basic container up and running. Any further customization can be done remotely, by either:
* `ssh`ing and performing manual customization, or
* scripted (`ssh devcon "bash -s" < ~/.bs/postinstall.sh`)

#### Customization as `root`
There should be minimal (if any) further customizations that need to be done as root. For example, if anything else needs to be installed, it should probably be built into a different image (so the install cost is incurred at build time). For example, [devcon-wm](https://github.com/alanmquach/devcon-wm/) builds on top if this core image to install a graphical environment.

##### `docker exec`
To run additional customization commands as root, simply run:
```
docker exec prime /bin/sh -c 'echo "hello world" > /root/protected.txt'
```

##### `/tmp/bootstrap.sh`
Alternatively, `/tmp/bootstrap.sh` optionally takes a bash script as its third argument:
```
docker run -d -p XXXXX:22 -p 60000-60010:60000-60010/udp alanmquach/devcon-wm:latest \
  -v ./customizations:/tmp/customizations
  /tmp/bootstrap.sh "developer" "public_key" "/tmp/customizations/customize.sh"
```
`/tmp/bootstrap.sh` will invoke the script provided right before launching `sshd`. The best way to use this is to mount the script and all its dependencies into the container (`-v ./customizations:/tmp/customizations`).
