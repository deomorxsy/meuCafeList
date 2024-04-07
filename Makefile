SHELL=/bin/bash

skeleton=$(shell source ./scripts/setup.sh; mvn_skeleton)
spring=$(shell source ./scripts/setup.sh; spring_setup)

test:
	docker compose -f ./compose.yml run

local:
	mvn install -f ./server/pom.xml
	mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e


up:
	docker compose -f ./compose.yml up

down:
	docker compose -f ./compose.yml down

build:
	docker compose -f ./compose.yml build

scaff:
	@echo "[Scaffolding] creating directory structure..."
	@$(call skeleton)
	@echo "[Scaffolding] setting up SpringBoot..."
	@$(call spring)
