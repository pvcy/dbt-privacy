# Installing and Running Tests
See the README in the integration_tests directory

# Creating a Release
1. Build and test the project locally against Postgres using `make init` and then `make test`
2. Create a release branch
2. Bump the version number in `dbt_project.yml`
3. To update published docs site, **from the integration tests directory**, run `make ../docs`
4. Merge release branch to main
5. Create a tag and cut a release in GitHub

Note: No further action is necessary to publish the package to the dbt Package Hub