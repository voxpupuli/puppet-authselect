# authselect

Manage authselect profile on systems that support it.

This module does not create custom profiles or deploy them.
For consistency, you are advised to package them up and then
deploy that package rather than build them ad-hoc.

## Table of Contents

- [authselect](#authselect)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [What authselect affects](#what-authselect-affects)
    - [Setup Requirements](#setup-requirements)
  - [Usage](#usage)
  - [Development](#development)

## Description

Set your `authselect` profile and any required features.

## Setup

### What authselect affects

This will alter your host's fundemental authentication and lookups via authselect.
Understand what that means before using it.

### Setup Requirements

You will need to start any required services **BEFORE** the authselect class runs.

This class does not track things like `sssd` or `winbind` services.

You may use `Class[authselect]` or `Exec[authselect set profile]` to ensure your services are running.

## Usage

Example class invocation:

```puppet
class { 'authselect':
  profile => 'sssd',
  profile_options => [ 'with-mkhomedir', 'with-faillock']
}
```
And the Hiera file would look like:
```yaml
authselect::profile: sssd
authselect::profile_options:
  - with-mkhomedir
  - without-pam-u2f-nouserok
```

This class also provides two facts: `authselect_profile` and `authselect_profile_features`.

## Development

Folks should use the repo listed in `metadata.json`.
