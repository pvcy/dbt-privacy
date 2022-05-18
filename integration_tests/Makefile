.PHONY: test
test:
	pipenv run dbt build --profiles-dir .
	
.PHONY: init
init:
	pipenv install --dev
	docker-compose up -d
	pipenv run dbt deps
	
.PHONY: clean
clean:
	pipenv run dbt clean
	pipenv --rm
	docker-compose down

.PHONY: fmt
fmt:
	pipenv run sqlfmt models
	
.PHONY: psql
psql:
	PGPASSWORD=for_testing_only psql -h localhost -U test_user -d postgres

../docs: $(wildcard ../macros/**/*)
	pipenv run dbt docs generate --profiles-dir .
	mv target/catalog.json target/index.html target/manifest.json target/run_results.json ../docs