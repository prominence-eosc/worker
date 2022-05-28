# PROMINENCE worker
Workers can be run directly on bare metal or in a VM, or alternative can be run inside a Docker container.

## Example running a worker using Docker
```
export use_hostname="<hostname>"
export cloud="<cloud name>"
export condor_host="<server>"
export region="<region>"
export node_group="<owner>"
export cluster="<id>"
export worker_type="shared"
export allow_parallel="false"
export schedd_name="<schedd name>"

docker run -d \
           --net=host \
           --hostname=$use_hostname \
           -e PROMINENCE_WORKER_TYPE=$worker_type \
           -e PROMINENCE_PARALLEL=$allow_parallel \
           -e PROMINENCE_CLOUD=$cloud \
           -e PROMINENCE_REGION=$region \
           -e PROMINENCE_NODE_GROUP=$node_group \
           -e PROMINENCE_SCHEDD_NAME=$schedd_name \
           -v /var/log/condor:/var/log/condor \
           -v /opt/prominence:/home \
           -v ${PWD}/token.jwt:/etc/condor/tokens.d/token.jwt \
           -e CONDOR_CLOUD=$cloud \
           -e CONDOR_CLUSTER=$cluster \
           -e CONDOR_HOST=$condor_host \
           --name=prominence-worker \
           --privileged=true \
           eoscprominence/worker:latest
```           
where `<hostname>` is the hostname of the worker, `<cloud name>` is the site name, `<server>` is the IP address of the PROMINENCE server, `<region>` is the region, `<owner>` is the name of the group owning this resource. To allow paralle jobs to run set `allow_parallel` to `true`. `schedd_name` is only needed if parallel jobs are allowed. If the worker should run only a single job, set `worker_type` to `dedicated` and `<id>` to the job id. In the above it is assume that there is a worker token `token.jwt` in the current directory.
