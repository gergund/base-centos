#!/bin/bash
docker run --privileged --name base -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 8022:22 -dt base-centos
#docker kill base && docker rm base && docker run --privileged --name base -p 8022:22 -dt base-centos
