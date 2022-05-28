# PROMINENCE worker
Workers can be run directly on bare metal or in a VM, or alternatively can be run inside a Docker container. They can either run
indefinitely or shutdown after being idle for a specified timeout.

## Example running a worker using Docker
```
docker run -d \
           --net=host \
           --name=prominence-worker \
           --privileged=true \
           -e PROMINENCE_CLOUD=$cloud \
           -e PROMINENCE_REGION=$region \
           -e PROMINENCE_NODE_GROUP=$node_group \
           -e PROMINENCE_SCHEDD_NAME=$schedd_name \
           -e PROMINENCE_JOB_ID=$job_id \
           -e PROMINENCE_COLLECTOR=$condor_host \
           -e PROMINENCE_IDLE_TIMEOUT=$idle_timeout \
           -v /var/log/condor:/var/log/condor \
           -v /opt/prominence:/home \
           -v ${PWD}/token.jwt:/etc/condor/tokens.d/token.jwt \
           eoscprominence/worker:latest
```
Here:
* `PROMINENCE_CLOUD`: name of the cloud
* `PROMINENCE_REGION`: name of the region
* `PROMINENCE_NODE_GROUP`: name of primary group owning this resource
* `PROMINENCE_COLLECTOR`: IP address of PROMINENCE server
* `PROMINENCE_SCHEDD_NAME`: (optional) to allow parallel jobs to run set this to the name of the HTCondor schedd
* `PROMINENCE_JOB_ID`: (optional) if defined the worker will only run the job with this id
* `PROMINENCE_IDLE_TIMEOUT`: (optional) if defined the worker will shutdown after being idle for this number of seconds

Note that `--privileged=true` is only needed to support the Singularity container runtime. udocker works without this.
