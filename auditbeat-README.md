Eagerly waiting for Docker 19.06 release which will bring --privileged flag to Docker Swarm Mode https://github.com/moby/moby/issues/24862#issuecomment-451594187. support for capabilities https://github.com/moby/moby/pull/38380

Until capabilities are available in docker swarm mode, execute the following instructions on each node where auditbeat is required

Firstly, set the system variables as needed:
- export ELASTIC_VERSION=7.9.1
- export ELASTICSEARCH_USERNAME=elastic
- export ELASTICSEARCH_PASSWORD=changeme
- export ELASTICSEARCH_HOST=node1
- export KIBANA_HOST=node1
- export NODE_NAME=node1

And than run the command below:
```
    docker container run \
    --rm --detach \
    --hostname=${NODE_NAME:-node1}-auditbeat \
    --name=auditbeat \
    --user=root \
    --volume=$PWD/elk/beats/auditbeat/config/auditbeat.yml:/usr/share/auditbeat/auditbeat.yml \
    --cap-add="AUDIT_READ" \
    --cap-add="AUDIT_CONTROL" \
    --pid=host \
    --volume=/var/run/docker.sock:/var/run/docker.sock \
    --env ELASTICSEARCH_USERNAME=${ELASTICSEARCH_USERNAME:-elastic} \
    --env ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD:-changeme} \
    --env ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST:-node1} \
    --env KIBANA_HOST=${KIBANA_HOST:-node1} \
    docker.elastic.co/beats/auditbeat:${ELASTIC_VERSION:-7.9.1} \
    --strict.perms=false
```

> Unfortunately, Centos 7 doesn't know about `CAP_AUDIT_READ`. It was added in kernel version 3.16, but Centos 7 runs kernel version 3.10.
