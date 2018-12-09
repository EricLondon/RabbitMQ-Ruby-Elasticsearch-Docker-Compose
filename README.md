# RabbitMQ, Ruby, Elasticsearch, Worker, Docker Compose

See blog post: https://ericlondon.com/2018/12/09/using-rabbitmq-as-a-ruby-work-queue-to-populate-elasticsearch-via-docker-compose.html

```
# build and start docker container
docker-compose build && docker-compose --compatibility up

# review docker containers
# NOTE: as expected, the producer container exited after queuing all the tasks
docker ps -a
CONTAINER ID  IMAGE                                                COMMAND                 CREATED             STATUS                     PORTS                                                  NAMES
8d0e832f2deb  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_10
5420e004c788  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_4
3d0d70b04310  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_5
e2bc549a2cbb  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_7
11445b7c6295  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_3
5a27d37015c4  rabbitmq_app_producer                                "/app/producer.rb"      About a minute ago  Exited (0) 49 seconds ago                                                         rabbitmq_app_producer_1
a51bcb127e76  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_2
42bfd224e65e  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_9
9307e547454b  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_1
d49337e9c5a8  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_8
ebf2e23a8736  rabbitmq_app_worker                                  "/app/worker.rb"        About a minute ago  Up About a minute                                                                 rabbitmq_app_worker_6
788244fb1620  rabbitmq:latest                                      "docker-entrypoint.s…"  About a minute ago  Up About a minute          4369/tcp, 5671/tcp, 25672/tcp, 0.0.0.0:5672->5672/tcp  rabbitmq_rabbitmq_1
ec59a0e8f744  docker.elastic.co/elasticsearch/elasticsearch:6.5.2  "/usr/local/bin/dock…"  About a minute ago  Up About a minute          0.0.0.0:9200->9200/tcp, 9300/tcp                       elasticsearch

# query elasticsearch
curl 'http://localhost:9200/people/_search?pretty&size=1'
{
  "took" : 43,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1000,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "people",
        "_type" : "person",
        "_id" : "ZmiIjmcBxEAUMv2VhCO2",
        "_score" : 1.0,
        "_source" : {
          "first_name" : "Eric",
          "last_name" : "London",
          "email" : "eric@example.com"
        }
      }
    ]
  }
}
```
