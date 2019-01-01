FROM raspbian/jessie:latest
LABEL maintainer="Dan Kempster"

ENV DEBIAN_FRONTEND noninteractive

ENV pip_packages "setuptools ansible cryptography"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo systemd \
       build-essential libffi-dev libssl-dev \
       python-pip python-dev python-setuptools python-wheel \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Install Ansible via pip.
RUN pip install $pip_packages

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible invwentory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
