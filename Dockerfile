
FROM centos:7
MAINTAINER GergunD <gergund@gmail.com>
ENV container docker

RUN yum install -y  https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
RUN yum clean all
RUN yum update -y
RUN yum install -y systemd systemd-libs

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y openssh-server.x86_64 openssh-clients.x86_64 openssh.x86_64 passwd sudo
RUN systemctl enable sshd.service

RUN groupadd stack && useradd -u 1001 -g stack -m stack && echo "stack" | passwd stack --stdin
RUN ssh-keygen -A -v

RUN sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/sshd && \
    sed -i 's/Defaults.*requiretty/#Defaults requiretty/g' /etc/sudoers && \
    rm /usr/lib/tmpfiles.d/systemd-nologin.conf

RUN echo "stack	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
