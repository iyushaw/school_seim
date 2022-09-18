SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help
.PHONY: clean build logs run rm shell

ELK_NETWORK_NAME = elastic

LOGSTASH_CONTAINER_IMAGE = logstash
LOGSTASH_CONTAINER_NAME = logstash
LOGSTASH_CONTAINER_TAG = 7.17.6
LOGSTASH_CONTAINER_PORT = 5044


ELASTIC_CONTAINER_IMAGE = elasticsearch
ELASTIC_CONTAINER_NAME = elastic
ELASTIC_CONTAINER_TAG = 7.17.6
ELASTIC_CONTAINER_PORT_HTTP = 9200
ELASTIC_CONTAINER_PORT = 9300
ELASTIC_DEPLOYMENT_TYPE = single-node


KIBANA_CONTAINER_IMAGE = kibana
KIBANA_CONTAINER_NAME = kibana
KIBANA_CONTAINER_TAG = 7.17.6
KIBANA_CONTAINER_PORT = 5601

help:
	@echo ''
	@echo 'Makefile will build containers based on the following arguments'
	@echo '	make clean 	removes all containers and images'
	@echo '	make build-logstash	build logstash image'
	@echo '	make build-elastic	build elastic image'
	@echo '	make build-kibana	build kibana image'
	@echo '	make build-kafka	build kafka image'
	@echo '	make logs		taps into logs of a container'
	@echo '	make run		run container'
	@echo '	make rm			remove container'

clean:
	docker stop $(KIBANA_CONTAINER_NAME) $(LOGSTASH_CONTAINER_NAME) $(ELASTIC_CONTAINER_NAME);
	docker rm $(KIBANA_CONTAINER_NAME) $(LOGSTASH_CONTAINER_NAME) $(ELASTIC_CONTAINER_NAME);
	docker network rm $(ELK_NETWORK_NAME)
	
build:
	docker network create $(ELK_NETWORK_NAME);
	docker start $(LOGSTASH_CONTAINER_NAME) $(ELASTIC_CONTAINER_NAME) $(KIBANA_CONTAINER_NAME)

build_logstash:
	docker run \
	-d \
	--rm \
	-it \
	-v ~/logstash:/usr/share/logstash/pipeline/logstash
	--name $(LOGSTASH_CONTAINER_NAME) \
	-p $(LOGSTASH_CONTAINER_PORT):$(LOGSTASH_CONTAINER_PORT)/udp \
	--net $(ELK_NETWORK_NAME) \
	$(LOGSTASH_CONTAINER_IMAGE):$(LOGSTASH_CONTAINER_TAG)

build_elastic:
	docker run \
	-d \
	--rm \
	-it \
	--name $(ELASTIC_CONTAINER_NAME) \
	-p $(ELASTIC_CONTAINER_PORT_HTTP):$(ELASTIC_CONTAINER_PORT_HTTP) \
	-p $(ELASTIC_CONTAINER_PORT):$(ELASTIC_CONTAINER_PORT) \
	-e "discovery.type=$(ELASTIC_DEPLOYMENT_TYPE)" \
	--net $(ELK_NETWORK_NAME) \
	$(ELASTIC_CONTAINER_IMAGE):$(ELASTIC_CONTAINER_TAG)

build_kibana:
	docker run \
	-d \
	--rm \
	-it \
	--name $(KIBANA_CONTAINER_NAME) \
	-p $(KIBANA_CONTAINER_PORT):$(KIBANA_CONTAINER_PORT) \
	--net $(ELK_NETWORK_NAME) \
	$(KIBANA_CONTAINER_IMAGE):$(KIBANA_CONTAINER_TAG)

build_kafka:

logs:

run:

rm:



