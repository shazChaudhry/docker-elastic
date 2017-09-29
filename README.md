[![Build Status on Travis](https://travis-ci.org/shazChaudhry/logging.svg?branch=master "CI build status on Travis")](https://travis-ci.org/shazChaudhry/logging)

### User story
As a DevOps team member, I want to install [Elastic Stack](https://www.elastic.co/products) so that all application and system logs are collected centrally for searching, visualizing, analyzing and reporting purpose

### Assumptions
All containerized application services will start with [GELF](http://docs.graylog.org/en/2.2/pages/gelf.html) log driver in order to send logs to Elastic Stack

### Prerequisite
* Infrastructre is setup in [Docker swarm mode](https://docs.docker.com/engine/swarm/)
* On each cluster node, ensure maximum map count check _(required for Elasticsearch)_ is set: `sudo sysctl -w vm.max_map_count=262144`

### Installation instructions
* Login to the master node in your Docker Swarm cluster
* Clone this repo and change directory by following these commands
```
  alias git='docker run -it --rm --name git -v $PWD:/git -w /git indiehosters/git git'
  git version
  git clone https://github.com/shazChaudhry/elastic.git
  sudo chown -R $USER elastic
  cd elastic
  ```
* Deploy stack by running the following command:
  * `ELASTIC_VERSION=5.6.2 docker stack deploy -c docker-compose.yml elastic`
* Check status of the stack services by running the following commands:
  *   `docker stack services elastic`
  *   `docker stack ps elastic`

### Testing
* Wait until all stack services are up and running
* Run jenkins container on one of the Docker Swarm node as follows:
  * `docker run -d --rm --name jenkins -p 8080:8080 --log-driver=gelf --log-opt gelf-address=udp://127.0.0.1:12201  jenkinsci/jenkins`
    * Note that _`--log-driver=gelf --log-opt gelf-address=udp://127.0.0.1:12201`_ sends container console logs to Elastic stack
* Login at `http://<master_node_ip>:5601` _(Kibana)_  which should show Management tab
  * username = `elastic`
  * password = `changeme`
* On the Kibana Management tab, configure an index pattern
  * Index name or pattern = `logstash-*`
  * Time-field name = `@timestamp`
* Click on Kibana Discover tab to view jenkins console logs
* On the Kibana Management tab, configure an index pattern
  * Index name or pattern = `logstash-*`
  * Time-field name = `@timestamp`
* Click on Kibana Discover tab to view container system/container metric send by metricbeat

### References
- [Installing Elastic Stack](https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html)
- [Elastic Examples](https://github.com/elastic/examples)
- [ Machine Learning in the Elastic Stack - YouTube](https://www.youtube.com/watch?v=n6xW6YWYgs0&feature=youtu.be)
