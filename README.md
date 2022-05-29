# PROMINENCE worker
Workers can be run directly on bare metal or in a VM, or alternatively can be run inside a Docker container. They can either run
indefinitely or shutdown automatically after being idle for a specified timeout.

A worker requires a token in order to join the PROMINENCE worker pool. Note that this is a different token to the access token used by
users to manage jobs.

PROMINENCE admins can create tokens by running the following command:
```
condor_token_create -identity worker@cloud -key token_key
```

It is also possible for users to launch their own workers. They will only be able to run jobs of the user who launches them. This functionality is leveraged to enable jobs to be run on HPC resources. Using curl and jq a worker token can be obtained from a valid user token as follows:
```
export PROMINENCE_WORKER_TOKEN=`curl -s -X POST -H "Authorization: Token $PROMINENCE_TOKEN" $PROMINENCE_URL/token | jq '.token' | tr -d '"'`
```
where the environment variable `PROMINENCE_TOKEN` contains the user token and `PROMINENCE_URL` is the URL of the PROMINENCE API.

## Deployment options

### Docker
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

Also, the above example assumes that there is a worker token `token.jwt` in the current directory.

Note that `--privileged=true` is only needed to support the Singularity container runtime. udocker works without this.
