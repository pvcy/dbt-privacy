# dbt-privacy
Package of macros for [dbt](https://github.com/dbt-labs/dbt) to make it easier to protect your customers' data

## About Privacy Dynamics
Privacy Dynamics provides tools to empower innovative and ethical data teams. Our solutions include sophisticated privacy transformations that reduce reidentification risk but leave data usable for analysts and data scientists. For more information, visit https://www.privacydynamics.io

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/pvcy/dbt_privacy/latest/) for
the latest installation instructions, or [read dbt's docs](https://docs.getdbt.com/docs/package-management)
for more information on installing packages.

## Macros in this Package
Note that macros in this package are designed to work across Postgres, Snowflake, BigQuery, and Redshift data warehouses, but as of April 2022, we have only tested the macros against Postgres and Snowflake.

### hash
[Source](macros/hash.sql)

Returns a SHA2 hex digest of `expr`; lowercases and adds a pepper before
hashing by default. For additional security, set `salt_expr` to a value
with the same or higher cardinality as `expr` (e.g., if `expr='email'`, then a 
good salt would be `salt_expr='user_id'`). Also set the 
`DBT_PRIVACY_PEPPER_SEED` environment variable to a random value; 
see docs for `generate_pepper` for more information.

NOTE: The value of `DBT_PRIVACY_PEPPER_SEED` will be visible in the compiled 
model code and in query logs. If an attacker has access to the code and the
data, they will be able to construct a rainbow table for this hash method
unless `salt_expr` is also provided.

For more information, see the docs generated in your project.

Example Usage:
```
{{ dbt_privacy.hash(
    "email",
    lowercase=true,
    salt_expr="user_id",
    pepper_scope="model",
    pepper_persistence="permanent",
    digest_size=256
) }}
{{ dbt_privacy.hash("full_name", salt_expr="user_id") }}
```

### hash_unique
[Source](macros/hash_unique.sql)

Returns a SHA2 hex digest of `expr`, if `expr` is unique* in its context; 
lowercases and adds a pepper before
hashing by default. For additional security, set `salt_expr` to a value
with the same or higher cardinality as `expr` (e.g., if `expr='email'`, then a 
good salt would be `salt_expr='user_id'`). Also set the 
`DBT_PRIVACY_PEPPER_SEED` environment variable to a random value; 
see docs for `generate_pepper` for more information.

"Unique" means that the number of rows partitioned by `expr` in the 
current window is <= `n`, where `n` defaults to 1 but is configurable.

NOTE: The value of `DBT_PRIVACY_PEPPER_SEED` will be visible in the compiled 
model code and in query logs. If an attacker has access to the code and the
data, they will be able to construct a rainbow table for this hash method
unless `salt_expr` is also provided.

For more information, see the docs generated in your project.

Example Usage:
```
{{ dbt_privacy.hash_unique(
    "zip_code",
    lowercase=false,
    salt_expr="state",
    pepper_scope="model",
    pepper_persistence="permanent",
    digest_size=256,
    n=5
) }}
{{ dbt_privacy.hash_unique("zip_code", salt_expr="state") }}
```

### redact_unique
[Source](macros/redact_unique.sql)

Returns `redact_expr` instead of `expr`, if `expr` is unique* in its context;
lowercases before checking for uniqueness by default.

"Unique" means that the number of rows partitioned by `expr` in the 
current window is <= `n`, where `n` defaults to 1 but is configurable.

For more information, see the docs generated in your project.

Example Usage:
```
{{ dbt_privacy.redact_unique(
    "zip_code", 
    lowercase=false, 
    redact_expr="'**REDACTED**'", 
    n=5
) }}
```