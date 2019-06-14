The examples here are for learning purpose only and show how to start filebeat and then visualize data in kibana. The examples here have been taken from GitHub [Elasticsearch examples](https://github.com/elastic/examples) that are available to everyone.

### Versions
Example has been tested in following versions:
- Elasticsearch 7.1.1
- Kibana 7.1.1
- Filebeat 7.1.1


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
docker.elastic.co/beats/filebeat:7.1.1 \
-e --modules=nginx --setup  -M "nginx.access.var.paths=[/tmp/nginx_logs]" \
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

### Exploring Public Datasets
[NYC traffic accidents](https://github.com/elastic/examples/tree/master/Exploring%20Public%20Datasets/nyc_traffic_accidents) was used as an example that demonstrates how to analyze & visualize New York City traffic incident data using the Elastic Stack, i.e. Elasticsearch and Kibana. The [NYPD Motor Vehicle Collision data](https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?) analyzed in this example is from the [NYC Open Data](https://opendata.cityofnewyork.us/) initiative.

Assuming you are on node3, execute the commands below:
```
mkdir nyc_collision && cd nyc_collision && \
# nyc_collision_data.csv - CSV version of the NYPD Motor Vehicle Collision dataset
wget https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD -O nyc_collision_data.csv && \
# nyc_collision_filebeat.yml - Filebeat config for ingesting data into Elasticsearch
wget https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_filebeat.yml && \
# nyc_collision_template.json - template for custom mapping of fields
wget https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_template.json && \
# nyc_collision_kibana.json - config file to load prebuilt Kibana dashboard
wget https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_kibana.json && \
# nyc_collision_pipeline - ingest pipeline for processing csv lines
wget https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_pipeline.json && \
curl -XPUT -u elastic:changeme -H 'Content-Type: application/json' 'node1:9200/_ingest/pipeline/nyc_collision' -d @nyc_collision_pipeline.json && \
curl -XPUT -u elastic:changeme -H 'Content-Type: application/json' 'node1:9200/_template/nyc_collision' -d @nyc_collision_template.json && \
chmod go-w ./nyc_collision_filebeat.yml
```
Modify the paths to `/tmp/nyc_collision_data.csv` and replace the word _prospectors_ with `inputs` in nyc_collision_filebeat.yml
```
docker container run --name filebeat --rm --network host --volume filebeat:/usr/share/filebeat/data --volume $PWD:/tmp docker.elastic.co/beats/filebeat:7.1.1 \
-e -c /tmp/nyc_collision_filebeat.yml \
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
Follow the "[Visualize data in Kibana](https://github.com/elastic/examples/tree/master/Exploring%20Public%20Datasets/nyc_traffic_accidents#2-visualize-data-in-kibana)" instrictions to see data in Kibana

For time period, select `Last 5 years`
