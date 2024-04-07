SHELL=/bin/bash

skeleton=$(shell source ./scripts/setup.sh; mvn_skeleton)
spring=$(shell source ./scripts/setup.sh; spring_setup)
compose=$(shell source ./scripts/ccr.sh; call checker)

test:
	docker compose -f ./compose.yml run

local:
	mvn install -f ./server/pom.xml
	mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" -f ./server/pom.xml -e


up:
	@$(call compose)
	docker compose -f ./compose.yml up

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
