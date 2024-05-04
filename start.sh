docker run --rm -it --name sr --sysctl net.ipv6.conf.all.disable_ipv6=0 --dns=1.1.1.1 --privileged --cap-add net_admin -v /lib/modules:/lib/modules sr:latest
