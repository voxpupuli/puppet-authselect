# authselect

Manage authselect profile on systems that support it.

## Table of Contents

- [authselect](#authselect)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [What authselect affects](#what-authselect-affects)
    - [Setup Requirements](#setup-requirements)
  - [Usage](#usage)
    - [Basic class usage](#basic-class-usage)
    - [Creating and selecting a custom profile](#creating-and-selecting-a-custom-profile)
    - [Facts](#facts)
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

### Basic class usage
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
### Creating and selecting a custom profile
Example custom profile configuration:

```puppet
class { 'authselect
  profile_manage  => true,
  profile         => 'custom/new_profile',
  custom_profiles => {
    'new_profile' => {
      'base_profile' => 'sssd',
      'contents' => {
        'nsswitch.conf' => {
          'content' => '<your custom nsswitch content here>'
        }
      }
    }
  }
}
```

And the Hierafile would look like:
```yaml
authselect::profile_manage: true
authselect::profile: 'custom/new_profile'
authselect::custom_profiles:
  new_profile:
    base_profile: 'sssd'
    contents:
      nsswitch.conf:
        content: '<your custom nsswitch content here>'
```

The code above will create a new custom authselect profile called 'new_profile'. The profile will be based off of the sssd profile. The profile will also contain an nsswitch file that will contain the custom content specified in the `content` parameter. To use the new custom profile the `authselect::profile` parameter will need to prefix the name of the custom profile with `custom/` as shown above.

### Facts
This class also provides two facts: `authselect_profile` and `authselect_profile_features`.

## Development

Folks should use the repo listed in `metadata.json`.
