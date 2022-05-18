# dbt-privacy
Package of macros for [dbt](https://github.com/dbt-labs/dbt) to make it easier to protect your customers' data

## About Privacy Dynamics
Privacy Dynamics provides tools to empower innovative and ethical data teams. Our solutions include sophisticated privacy transformations that reduce reidentification risk but leave data usable for analysts and data scientists. For more information, visit https://www.privacydynamics.io

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/pvcy/dbt_privacy/latest/) for
the latest installation instructions, or [read dbt's docs](https://docs.getdbt.com/docs/package-management)
for more information on installing packages.

## Macros in this Package
Note that macros in this package are designed to work across Postgres, Snowflake, BigQuery, and Redshift data warehouses, but as of May 2022, we have only tested the macros against Postgres and Snowflake.

[Click Here](https://pvcy.github.io/dbt-privacy/) to view the dbt docs site for the macros in this package.

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

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

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

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

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

### mask
[Source](macros/mask.sql)

Unless `expr` is null, replaces `expr` with a string of the same length,
but with the contents replaced by `mask_char`.

If `keep_n > 0`, includes `keep_n` characters from the original `expr`,
from the direction `keep_dir`.

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

Example Usage:
```
{{ dbt_privacy.mask("first_name") }}
# input: Ted
# output: ***
# input: Matthew
# output: *******

{{ dbt_privacy.mask(
    "phone_number",
    keep_n=4,
    keep_dir="right"
) }}
# input: +12125551234
# output: ********1234
```

### mask_email
[Source](macros/mask_email.sql)

Splits an email address into its address and domain parts.
Will `safe_mask` the address and also `safe_mask` the domain, if
there are fewer than `domain_n` records with that domain.

Returns `null` if `expr` is `null`, but does not return `null` if `expr`
is not a valid email address (with no "@").

Note: Masking unique domains is important for protecting individuals
with addresses like `personal@famouscelebrity.com`

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

Example Usage:
```
{{ dbt_privacy.mask_email("email") }}
# input: ted@example.com
# output: ********@********

{{ dbt_privacy.mask_email(
    "email", 
    n=4,
    domain_n=0,
) }}
# input: ted@example.com
# output: ****@example.com
```

### redact_unique
[Source](macros/redact_unique.sql)

Returns `redact_expr` instead of `expr`, if `expr` is unique* in its context;
lowercases before checking for uniqueness by default.

"Unique" means that the number of rows partitioned by `expr` in the 
current window is <= `n`, where `n` defaults to 1 but is configurable.

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

Example Usage:
```
{{ dbt_privacy.redact_unique(
    "zip_code", 
    lowercase=false, 
    redact_expr="'**REDACTED**'", 
    n=5
) }}
```

### safe_mask
[Source](macros/safe_mask.sql)

Unless `expr` is null, replaces `expr` with a string of length
`n + keep_n`, consisting of a fixed number (`n`) of `mask_char`s.

If `keep_n > 0`, includes `keep_n` characters from the original `expr`,
from the direction `keep_dir`.

For more information, see the [docs](https://pvcy.github.io/dbt-privacy/).

Example Usage:
```
{{ dbt_privacy.safe_mask("phone_number") }}
# input: +12125551234
# output: ********

{{ dbt_privacy.safe_mask(
    "phone_number", 
    n=8,
    keep_n=4,
    keep_dir="right"
) }}
# input: +12125551234
# output: ********1234
```