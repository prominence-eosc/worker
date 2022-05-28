#!/bin/sh
echo "CONDOR_HOST = $CONDOR_HOST" > /etc/condor/config.d/docker
echo "COLLECTOR_HOST = $CONDOR_HOST:9618" >> /etc/condor/config.d/docker
echo "CCB_ADDRESS = $CONDOR_HOST:9618" >> /etc/condor/config.d/docker
echo "ProminenceCloud = \"$PROMINENCE_CLOUD\"" >> /etc/condor/config.d/docker
echo "ProminenceRegion = \"$PROMINENCE_REGION\"" >> /etc/condor/config.d/docker
echo "ProminenceNodeGroup = \"$PROMINENCE_NODE_GROUP\"" >> /etc/condor/config.d/docker

if [ "$PROMINENCE_WORKER_TYPE" = "dedicated" ]; then
  echo "START = ProminenceWantCluster =?= \"$CONDOR_CLUSTER\" && NODE_IS_HEALTHY =?= True" >> /etc/condor/config.d/docker
else
  echo "START = NODE_IS_HEALTHY =?= True" >> /etc/condor/config.d/docker
fi

if [ "$PROMINENCE_ALLOW_PARALLEL" = "true" ]; then
  echo "DedicatedScheduler = \"DedicatedScheduler@$PROMINENCE_SCHEDD_NAME\"" >> /etc/condor/config.d/docker
  echo "ParallelSchedulingGroup = \$(ProminenceCloud)" >> /etc/condor/config.d/docker
  echo "STARTD_ATTRS = \$(STARTD_ATTRS), DedicatedScheduler, ParallelSchedulingGroup" >> /etc/condor/config.d/docker
fi

python3 /usr/local/bin/write-resources.py $CONDOR_CLOUD

# Set ownership of token
chown condor:condor /etc/condor/tokens.d/token.jwt

# HTCondor execute directory
mkdir -p /home/prominence
chmod a+xrw /home/prominence
mkdir -p /home/prominence/condor
chown condor:condor /home/prominence/condor
mkdir -p /home/user/mounts
chown -R user:user /home/user
chown -R user:user /home/user/mounts

# Logs
mkdir -p /var/log/condor
chown condor:condor /var/log/condor

# Run HTCondor
/usr/sbin/condor_master -f
