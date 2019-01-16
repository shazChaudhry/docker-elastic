The examples here are for learning purpose only and have been taken from GitHub [Elasticsearch examples](https://github.com/elastic/examples) that are available to everyone. It's a great way to get started.

### Versions
Example has been tested in following versions:
- Elasticsearch 6.5.4
- Kibana 6.5.4
- Filebeat 6.5.4


### Prerequisites
Use the proved Vagrantfile to create 3x VMs:
- node1 and node2 _(Docker Swarm cluster)_ are for running ElasticSearch, Kibana and Logstash in swarm mode
  - Follow the instructions in [../README.md](../README.md) to deploy the Elastic Stack
- node3 is where filebeat examples below will be running


### Common Data Formats
[nginx_logs](https://github.com/elastic/examples/tree/master/Common%20Data%20Formats/nginx_logs) was used as an example to ingest, analyze & visualize NGINX access logs using the Elastic Stack, i.e. Elasticsearch, Filebeat and Kibana. The sample NGINX access logs in this example use the default NGINX combined log format.

In order to achieve this we use the Filebeat [Nginx module](https://www.elastic.co/guide/en/beats/filebeat/6.0/filebeat-module-nginx.html) per Elastic Stack best practices.

Assuming you are on node3, [install](https://www.elastic.co/guide/en/beats/filebeat/6.5/filebeat-installation.html) filebeat and download [sample data](https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/nginx_logs/nginx_logs) in "./nginx_logs" directory. Then execute the command below:
```
sudo /usr/bin/filebeat -e --modules=nginx --setup  -M "nginx.access.var.paths=[nginx_logs/nginx_logs]" \
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

### Exploring Public Datasets
[NYC traffic accidents](https://github.com/elastic/examples/tree/master/Exploring%20Public%20Datasets/nyc_traffic_accidents) was used as an example that demonstrates how to analyze & visualize New York City traffic incident data using the Elastic Stack, i.e. Elasticsearch and Kibana. The [NYPD Motor Vehicle Collision data](https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?) analyzed in this example is from the [NYC Open Data](https://opendata.cityofnewyork.us/) initiative.

Assuming you are on node3, [install](https://www.elastic.co/guide/en/beats/filebeat/6.5/filebeat-installation.html) filebeat and download sample data files. Then execute the command below:
```
sudo /usr/bin/filebeat -e -c /etc/filebeat/nyc_collision_filebeat.yml \
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
