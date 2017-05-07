[![Build Status on Travis](https://travis-ci.org/shazChaudhry/logging.svg?branch=master "CI build status on Travis")](https://travis-ci.org/shazChaudhry/logging)

**User story**
- As a DevOps team member I want to install [Elastic Stack](https://www.elastic.co/products) so that I can collect all application logs centrally for searching, visualizing, analysing and reporting purpose

**Assumptions**
* Your infrastucture is required to be based on ubuntu/xenial64
* Your infrastructure is required to have [Docker Swarm cluster](https://docs.docker.com/get-started/part4/#understanding-swarm-clusters) configuration
* On each cluster node, maximum map count check _(required for Elasticsearch)_ is set by running `sysctl -w vm.max_map_count=262144` command
* Your Docker services are required to be configured with [GELF](http://docs.graylog.org/en/2.2/pages/gelf.html) log driver _(these services send console logs to Elastic Stack)_
  * [List of supported logging drivers](https://docs.docker.com/engine/admin/logging/overview/#supported-logging-drivers)

**Prerequisite**
* Set up a development infrastructre by following [Infra as Code](https://github.com/shazChaudhry/infra) repo on github

**Instructions**
* Log into the master node in the Docker Swarm cluster setup above
* Clone this repository and change directory to where repo is cloned to
* Deploy stack by running the following command:
  * `ELASTIC_VERSION=5.4.0 docker stack deploy -c docker-compose.yml logging`
* Check status of the stack services by running the following commands:
  *   `docker stack services logging`
  *   `docker stack ps logging`

**Testing**
* Wait until all stack services are up and running
* Run jenkins container on one of the Docker Swarm node as follows:
  * `docker run -d --rm --name jenkins -p 8080:8080 --log-driver=gelf --log-opt gelf-address=udp://node1:12201 -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/jenkins`
* Login at [http://node1:5601](http://node1:5601) _(Kibana)_  which should show Management tab
  * username = `elastic`
  * password = `changeme`
* On the Kibana Management tab, configure an index pattern
  * Index name or pattern = `logstash-*`
  * Time-field name = `@timestamp`
* Click on Kibana Discover tab to view jenkins console logs

**References**
- [Installing Elastic Stack](https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html)
- [Elastic Examples](https://github.com/elastic/examples)
