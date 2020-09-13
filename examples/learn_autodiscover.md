The purpose of these exmaples is to learn how to used [filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/configuration-autodiscover-hints.html#configuration-autodiscover-hints) and [metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/current/configuration-autodiscover.html#configuration-autodiscover) hint based autodiscover features for docker containers

### Prerequisites
Use the provided Vagrantfile to create 3x VMs:
- node1 and node2 _(Docker Swarm cluster)_ are for running ElasticSearch, Kibana and Logstash in swarm mode
  - Follow the instructions in [../README.md](../README.md) to deploy Elastic Stack
- node3 is for running filebeat and metricbeat in swarm mode. See instructions in [../README.md](../README.md)
- Examples below will be running on node3

### Versions
Example has been tested in following versions:
- Elasticsearch 7.9.1
- Kibana 7.9.1
- Filebeat 7.9.1
- Metricbeat 7.9.1

### Elastic Stack - Apache2 module
Ensure there is nothing listening on port 80.

This example has been taken from https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html#_customize_your_configuration
```
docker container run --rm \
--label co.elastic.logs/module=apache2 \
--label co.elastic.logs/fileset.stdout=access \
--label co.elastic.logs/fileset.stderr=error \
--label co.elastic.metrics/module=apache \
--label co.elastic.metrics/metricsets=status \
--label co.elastic.metrics/hosts='${data.host}:${data.port}' \
--detach=true \
--name apache \
--publish 80:80 \
httpd:latest
```

### Elastic Stack - Nginx module
Ensure there is nothing listening on port 80
```
docker container run --rm \
--label co.elastic.logs/module=nginx \
--label co.elastic.logs/fileset.stdout=access \
--label co.elastic.logs/fileset.stderr=error \
--label co.elastic.metrics/module=nginx \
--label co.elastic.metrics/metricsets=stubstatus \
--label co.elastic.metrics/hosts='${data.host}:${data.port}' \
--detach=true \
--name nginx \
--publish 80:80 \
nginx:latest
```

### Test
- Browse web page: http://node3
- Browse a non-existant page a few times e.g. http://node3/hello/world
- In Kibana, check filebeat and *metricbeat boards for apache / nginx

> *metricbeat - I am not entirely sure at the moment why no data is displayed in metricbeat boards :(
