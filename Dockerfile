FROM centos:7
  
# Dependencies
RUN yum -y install wget

# Install yum repository
RUN cd /etc/yum.repos.d && \
    wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-development-rhel7.repo

# Import signing key
RUN wget http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
    rpm --import RPM-GPG-KEY-HTCondor && \
    rm RPM-GPG-KEY-HTCondor

# Install HTCondor
RUN yum -y install condor

# Dependencies
RUN yum -y install singularity unzip bzip2 python2-pip python-devel gcc git openssl openssh-server python3 python3-pip

# Users
RUN useradd user
COPY add-users.sh /tmp/
RUN /tmp/add-users.sh

# Install udocker
RUN pip3 install git+https://github.com/indigo-dc/udocker

# Configuration
COPY 00-prominence-docker-worker /etc/condor/config.d/

# Scripts
COPY worker_health_check.py /usr/local/bin/
COPY write-resources.py /usr/local/bin/

# Entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

