The examples here are for learning purpose only and show how to start filebeat and then visualize data in kibana. The examples here have been taken from GitHub [Elasticsearch examples](https://github.com/elastic/examples) that are available to everyone.

### Versions
Example has been tested in following versions:
- Elasticsearch 7.9.1
- Kibana 7.9.1
- Filebeat 7.9.1


### Prerequisites
Use the provided Vagrantfile to create 3x VMs:
- node1 and node2 _(Docker Swarm cluster)_ are for running ElasticSearch, Kibana and Logstash in swarm mode
  - Follow the instructions in [../README.md](../README.md) to deploy the Elastic Stack
- node3 is where filebeat examples below will be running


### Common Data Formats
[nginx_logs](https://github.com/elastic/examples/tree/master/Common%20Data%20Formats/nginx_logs) was used as an example to ingest, analyze & visualize NGINX access logs using the Elastic Stack, i.e. Elasticsearch, Filebeat and Kibana. The sample NGINX access logs in this example use the default NGINX combined log format.

In order to achieve this we use the Filebeat [Nginx module](https://www.elastic.co/guide/en/beats/filebeat/6.0/filebeat-module-nginx.html) per Elastic Stack best practices.

Assuming you are on node3, execute the commands below:
```
mkdir nginx_logs && cd nginx_logs && wget https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/nginx_logs/nginx_logs

docker container run --rm \
--name filebeat \
--network host \
--volume filebeat:/usr/share/filebeat/data \
--volume $PWD:/tmp \
docker.elastic.co/beats/filebeat:7.9.1 \
-e --modules=nginx -M "nginx.access.var.paths=[/tmp/nginx_logs]" \
-E output.elasticsearch.hosts='node1:9200' \
-E output.elasticsearch.username=elastic \
-E output.elasticsearch.password=changeme \
-E setup.dashboards.enabled=true \
-E setup.kibana.host='node1:80' \
-E setup.kibana.username=elastic \
-E setup.kibana.password=changeme \
-E xpack.monitoring.enabled=true \
-E xpack.monitoring.elasticsearch=
```

Visualize data in Kibana _([Filebeat Nginx] Overview dashboard)_ by chhanging the time period from `2015-05-16 00:00:00.000` to `2015-06-05 23:59:59.999`