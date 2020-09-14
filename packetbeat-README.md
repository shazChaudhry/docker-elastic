> NOTE: Packetbeat does not appear to work in Swarm mode at the moment. See https://discuss.elastic.co/t/run-packetbeat-in-docker-swarm-mode/129937 for details. Support for capabilities is coming in v19.06 _(hopefully)_ https://github.com/moby/moby/pull/38380. This will also bring --privileged flag to Docker Swarm Mod _(hopefully)_ https://github.com/moby/moby/issues/24862#issuecomment-451594187

Eagerly waiting for Docker 19.06 release which will bring --privileged flag to Docker Swarm Mode https://github.com/moby/moby/issues/24862#issuecomment-451594187. support for capabilities https://github.com/moby/moby/pull/38380

Until capabilities are available in docker swarm mode, execute the following instructions on each node where packetbeat is required:

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
    --hostname=${NODE_NAME:-node1}-packetbeat \
    --name=packetbeat \
    --user=root \
    --volume=$PWD/elk/beats/packetbeat/config/packetbeat.yml:/usr/share/packetbeat/packetbeat.yml \
    --volume=/var/run/docker.sock:/var/run/docker.sock \
    --cap-add="NET_RAW" \
    --cap-add="NET_ADMIN" \
    --network=host \
    --env ELASTICSEARCH_USERNAME=${ELASTICSEARCH_USERNAME:-elastic} \
    --env ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD:-changeme} \
    --env ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST:-node1} \
    --env KIBANA_HOST=${KIBANA_HOST:-node1} \
    docker.elastic.co/beats/packetbeat:${ELASTIC_VERSION:-7.9.1} \
    --strict.perms=false
```
