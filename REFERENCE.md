# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`authselect`](#authselect): Manage authselect's active profile
* [`authselect::config`](#authselect--config): Configure authselect
* [`authselect::package`](#authselect--package): Manage the authselect package(s)

### Defined types

* [`authselect::custom_profile`](#authselect--custom_profile): Manage a custom authselect profile
* [`authselect::custom_profile_content`](#authselect--custom_profile_content): Manage file contents in a custom authselect profile

## Classes

### <a name="authselect"></a>`authselect`

This will select the requested authselect profile

group:      files systemd   {exclude if "with-custom-group"}
netgroup:   files           {exclude if "with-custom-netgroup"}
automount:  files           {exclude if "with-custom-automount"}
services:   files           {exclude if "with-custom-services"}
sudoers:    files           {include if "with-sudo"}'
          ensure: 'file'
          owner: 'root'
          group: 'root'
          mode: '0664'

#### Examples

##### Specifying a custom profile

```puppet
authselect::profile: 'custom/custom_profile_name'
```

##### Specifying a vendor profile

```puppet
authselect::profile: 'sssd'
```

##### Creating several profiles with different parameters

```puppet
authselect::custom_profiles:
  'local_user_minimal':
    base_profile: 'minimal'
  'local_user_linked_nsswitch':
    symlink_nsswitch: true
  'local_user_custom_nsswitch':
    contents:
      'nsswitch.conf':
        content: 'passwd:     files systemd   {exclude if "with-custom-passwd"}
```

#### Parameters

The following parameters are available in the `authselect` class:

* [`package_manage`](#-authselect--package_manage)
* [`package_ensure`](#-authselect--package_ensure)
* [`package_names`](#-authselect--package_names)
* [`profile_manage`](#-authselect--profile_manage)
* [`profile`](#-authselect--profile)
* [`profile_options`](#-authselect--profile_options)
* [`custom_profiles`](#-authselect--custom_profiles)

##### <a name="-authselect--package_manage"></a>`package_manage`

Data type: `Boolean`

Should this class manage the authselect package(s)

##### <a name="-authselect--package_ensure"></a>`package_ensure`

Data type: `String`

Passed to `package` `ensure` for the authselect package(s)

##### <a name="-authselect--package_names"></a>`package_names`

Data type: `Array[String[1], 1]`

Packages to manage in this class

##### <a name="-authselect--profile_manage"></a>`profile_manage`

Data type: `Boolean`

Should this class set the active profile

##### <a name="-authselect--profile"></a>`profile`

Data type: `String[1]`

Which authselect profile should be used.
Note: If using a custom (non-vendor) profile you must prefix the name with 'custom/'

##### <a name="-authselect--profile_options"></a>`profile_options`

Data type: `Array[String, 0]`

What options should we pass to authselect
ie, what features should be enabled/disabled?

##### <a name="-authselect--custom_profiles"></a>`custom_profiles`

Data type: `Hash`

Custom profiles to manage

### <a name="authselect--config"></a>`authselect::config`

Configure authselect

#### Examples

##### 

```puppet
include authselect::config
```

### <a name="authselect--package"></a>`authselect::package`

Manage the authselect package(s)

#### Examples

##### 

```puppet
include authselect::package
```

## Defined types

### <a name="authselect--custom_profile"></a>`authselect::custom_profile`

Manage a custom authselect profile

#### Examples

##### 

```puppet
authselect::custom_profile { 'namevar': }
```

#### Parameters

The following parameters are available in the `authselect::custom_profile` defined type:

* [`contents`](#-authselect--custom_profile--contents)
* [`base_profile`](#-authselect--custom_profile--base_profile)
* [`vendor`](#-authselect--custom_profile--vendor)
* [`symlink_meta`](#-authselect--custom_profile--symlink_meta)
* [`symlink_nsswitch`](#-authselect--custom_profile--symlink_nsswitch)
* [`symlink_pam`](#-authselect--custom_profile--symlink_pam)
* [`symlink_dconf`](#-authselect--custom_profile--symlink_dconf)

##### <a name="-authselect--custom_profile--contents"></a>`contents`

Data type: `Hash`

Custom profile contents use this only if you fully understand how authselect works!

Default value: `{}`

##### <a name="-authselect--custom_profile--base_profile"></a>`base_profile`

Data type: `Enum['sssd','winbind', 'nis', 'minimal']`

the profile to base your custom profile off of, defaults to sssd

Default value: `'sssd'`

##### <a name="-authselect--custom_profile--vendor"></a>`vendor`

Data type: `Boolean`

Specify whether this profile goes into the custom folder or the vendor profile in authselect
keep in mind that if you wish to select a custom profile you must prefix the name of the profile
with 'custom/' when setting authselect::profile

Default value: `false`

##### <a name="-authselect--custom_profile--symlink_meta"></a>`symlink_meta`

Data type: `Boolean`

Symlink meta files from the base profile instead of copying them

Default value: `false`

##### <a name="-authselect--custom_profile--symlink_nsswitch"></a>`symlink_nsswitch`

Data type: `Boolean`

Symlink nsswitch files from the base profile instead of copying them

Default value: `false`

##### <a name="-authselect--custom_profile--symlink_pam"></a>`symlink_pam`

Data type: `Boolean`

Symlink pam files from the base profile instead of copying them

Default value: `false`

##### <a name="-authselect--custom_profile--symlink_dconf"></a>`symlink_dconf`

Data type: `Boolean`

Symlink dconf files from the base profile instead of copying them

Default value: `false`

### <a name="authselect--custom_profile_content"></a>`authselect::custom_profile_content`

Manage file contents in a custom authselect profile

#### Examples

##### 

```puppet
authselect::custom_profile_content { 'myprofile/filename':
  content => "File contents\n",
}
```

#### Parameters

The following parameters are available in the `authselect::custom_profile_content` defined type:

* [`content`](#-authselect--custom_profile_content--content)
* [`path`](#-authselect--custom_profile_content--path)
* [`ensure`](#-authselect--custom_profile_content--ensure)
* [`owner`](#-authselect--custom_profile_content--owner)
* [`group`](#-authselect--custom_profile_content--group)
* [`mode`](#-authselect--custom_profile_content--mode)

##### <a name="-authselect--custom_profile_content--content"></a>`content`

Data type: `String`

The file resource `content` attribute

##### <a name="-authselect--custom_profile_content--path"></a>`path`

Data type:

```puppet
Pattern[
    /^\/etc\/authselect\/custom\/[^\/]+\/[^\/]+$/,
    /^\/usr\/share\/authselect\/vendor\/[^\/]+\/[^\/]+$/
  ]
```

The full path to the managed file

Default value: `"/etc/authselect/custom/${name}"`

##### <a name="-authselect--custom_profile_content--ensure"></a>`ensure`

Data type: `Stdlib::Ensure::File`

The file resource `ensure` attribute

Default value: `'file'`

##### <a name="-authselect--custom_profile_content--owner"></a>`owner`

Data type: `String[1]`

The file resource `owner` attribute

Default value: `'root'`

##### <a name="-authselect--custom_profile_content--group"></a>`group`

Data type: `String[1]`

The file resource `group` attribute

Default value: `'root'`

##### <a name="-authselect--custom_profile_content--mode"></a>`mode`

Data type: `Stdlib::Filemode`

The file resource `mode` attribute

Default value: `'0644'`

