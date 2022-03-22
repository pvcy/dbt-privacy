# Running Tests

Note: currently only tested on Postgres locally and Snowflake in the cloud.

## Testing locally against Postgres in Docker

1. You must have Docker, Make, and pipenv installed
1. `make init` will create a pg database in a docker container and install the project with pipenv
1. `make test` will run `dbt build` against the pg database
1. `make clean` will shut down the container and remove the virtual env

## Testing against Snowflake

Privacy Dynamics hosts a Snowflake warehouse and dbt Cloud project that can be used for CI testing. When you open a PR, after approval from the maintainers of this project, dbt Cloud will run `dbt build` against our Snowflake warehouse.