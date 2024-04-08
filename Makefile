SHELL=/bin/bash

skeleton=$(shell source ./scripts/setup.sh; mvn_skeleton)
spring=$(shell source ./scripts/setup.sh; spring_setup)
compose=$(shell source ./scripts/ccr.sh; checker)

test:
	docker compose -f ./compose.yml run

local:
	mvn install -f ./server/pom.xml
	mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

image:
	podman build -t localhost:5000/mcl_slimjre:v03 -f ./Dockerfile

# cronjob for the ci hook method to fetch the API on the mainClass
fetchapi:
	0 0 * * 1 /bin/mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

# cronjob for the ci hook method to convert the XML file (workflow artifact) to json format
xmltojson:
	0 0 * * 4 /bin/mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

# up containers
up:
	@$(call compose)
	docker compose -f ./compose.yml up
up_server:
	@$(call compose)
	docker compose -f ./compose.yml up server
up_client:
	@$(call compose)
	docker compose -f ./compose.yml up client

down:
	@$(call compose)
	docker compose -f ./compose.yml down

build:
	@$(call compose)
	docker compose -f ./compose.yml build

scaff:
	@echo "[Scaffolding] creating directory structure..."
	@$(call skeleton)
	@echo "[Scaffolding] setting up SpringBoot..."
	@$(call spring)
