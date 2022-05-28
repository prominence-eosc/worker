# PROMINENCE worker
Workers can be run directly on bare metal or in a VM, or alternatively can be run inside a Docker container.

## Example running a worker using Docker
```
export use_hostname="<hostname>"
export cloud="<cloud name>"
export condor_host="<server>"
export region="<region>"
export node_group="<owner>"
export job_id=<id>
export worker_type="shared"
export schedd_name="<schedd name>"
export idle_timeout=<idletimeout>

docker run -d \
           --net=host \
           --name=prominence-worker \
           --privileged=true \
           --hostname=$use_hostname \
           -e PROMINENCE_WORKER_TYPE=$worker_type \
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
where `<hostname>` is the hostname of the worker, `<cloud name>` is the site name, `<server>` is the IP address of the PROMINENCE server, `<region>` is the region, `<owner>` is the name of the group owning this resource. To allow paralle jobs to run set `schedd_name` to the name of the schedd. If the worker should run only a single job, set `worker_type` to `dedicated` and `<id>` to the job id. In the above it is assume that there is a worker token `token.jwt` in the current directory. The worker node will shutdown after being idle for `idle_timeout` seconds.

`--privileged=true` is only needed to support the Singularity runtime.
