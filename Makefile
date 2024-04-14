SHELL=/bin/bash

skeleton=$(shell source ./scripts/setup.sh; mvn_skeleton)
spring=$(shell source ./scripts/setup.sh; spring_setup)
#compose=$(shell source ./scripts/ccr.sh; checker)

test:
	docker compose -f ./compose.yml run

local:
	mvn install -f ./server/pom.xml
	mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

image:
	source ./scripts/ccr.sh; checker
	docker compose build -t localhost:5000/mcl_slimjre:v03 -f ./Dockerfile

# cronjob for the ci hook method to fetch the API on the mainClass
fetchapi:
	0 0 * * 1 /bin/mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

# cronjob for the ci hook method to convert the XML file (workflow artifact) to json format
xmltojson:
	0 0 * * 4 /bin/mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e

# up containers
up: up_server up_client
	#(call compose)
	docker compose -f ./compose.yml up
up_server:
	#(call compose)
	source ./scripts/ccr.sh; checker
	docker compose -f ./compose.yml up server
up_client:
	#(call compose)
	source ./scripts/ccr.sh; checker
	docker compose -f ./compose.yml up client

clean:
	#(call compose)
	docker compose -f ./compose.yml down

build: build_server build_client
build_server:
	source ./scripts/ccr.sh; checker
	docker compose -f ./compose.yml build server
build_client:
	source ./scripts/ccr.sh; checker
	docker compose -f ./compose.yml build client

scaff:
	@echo "[Scaffolding] creating directory structure..."
	@$(call skeleton)
	@echo "[Scaffolding] setting up SpringBoot..."
	@$(call spring)

