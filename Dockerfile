FROM centos:7
  
# Dependencies
RUN yum -y install wget epel-release

# Install yum repository
RUN yum install -y https://research.cs.wisc.edu/htcondor/repo/9.x/htcondor-release-current.el7.noarch.rpm

# Import signing key
RUN wget http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
    rpm --import RPM-GPG-KEY-HTCondor && \
    rm RPM-GPG-KEY-HTCondor

# Install HTCondor
RUN sed -i 's/priority=90/priority=40/g' /etc/yum.repos.d/htcondor.repo && \
    yum -y install condor

# Dependencies
RUN yum -y install singularity unzip bzip2 python2-pip python-devel gcc git openssl openssh-server python3 python3-pip

# Users
RUN useradd user
COPY add-users.sh /tmp/
RUN chmod a+xr /tmp/add-users.sh && \
    /tmp/add-users.sh && \
    rm -f /tmp/add-users.sh

# Install udocker
RUN pip3 install git+https://github.com/indigo-dc/udocker

# Configuration
COPY 00-prominence-worker /etc/condor/config.d/

# Scripts
COPY worker_health_check.py /usr/local/bin/
COPY write-resources.py /usr/local/bin/
RUN chmod a+xr /usr/local/bin/worker_health_check.py

# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod a+xr /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

