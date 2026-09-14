test:
	./gradlew test

start: run

run:
	./gradlew bootRun

update-gradle:
	./gradlew wrapper --gradle-version 9.2.1

update-deps:
	./gradlew versionCatalogUpdate

install:
	./gradlew dependencies

build:
	./gradlew build

lint:
	./gradlew spotlessCheck

lint-fix:
	./gradlew spotlessApply

.PHONY: build

build-image:
	docker build -t bulletin-app .

add-tag:
	docker tag bulletin:latest  alexamuek/project-devops-deploy:latest

push-image:
	docker push alexamuek/project-devops-deploy:latest
