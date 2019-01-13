#### Filebeat Apache2 module
This example has been taken from https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html#_customize_your_configuration
```
docker run \
--label co.elastic.logs/module=apache2 \
--label co.elastic.logs/fileset.stdout=access \
--label co.elastic.logs/fileset.stderr=error \
--label co.elastic.metrics/module=apache \
--label co.elastic.metrics/metricsets=status \
--label co.elastic.metrics/hosts='${data.host}:${data.port}' \
--detach=true \
--name httpd \
-p 80:80 \
httpd:2.4
```

#### Filebeat Nginx module
Ensure there is nothing listening on port 80 e.g. stop httpd
```
docker run \
--label co.elastic.logs/module=nginx \
--label co.elastic.logs/fileset.stdout=access \
--label co.elastic.logs/fileset.stderr=error \
--label co.elastic.metrics/module=nginx \
--label co.elastic.metrics/metricsets=stubstatus \
--label co.elastic.metrics/hosts='${data.host}:${data.port}' \
--detach=true \
--name nginx \
-p 80:80 \
nginx
```

#### Test
- Browse web page: http://node3 _(assuming you are using the provided Vagrantfile for the infra setup. Otherwise you will need to point your web browser to where the above apache2 was deployed)_
- Browse a non-existant page a few times e.g. http://node3/hello/world
- In Kibana, check filebeat and metricbeat boards for apache / nginx
