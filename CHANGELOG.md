# Changelog

All notable changes to this project will be documented in this file.

## Release 1.1.0
* Added the ability for users to create and manage custom profiles

## Release 1.0.1

**Bug Fixes**
* Authselect now runs correctly when changing profile, but leaving options alone

## Release 1.0.0

**Features**
* The exec which sets the profile now has a static name
* When not managing the profile, a noop exec is created with the static name for ordering purposes

**Breaking Change**

The exec resource which sets the profile is now statically named `authselect set profile`.

## Release 0.1.3

**Bug Fixes**
* Fix #2, better test coverage

## Release 0.1.2

**Bug Fixes**
* Fix #1, module not idempotent

## Release 0.1.1

**Bug Fixes**
* Fix typo in doc

## Release 0.1.0

**Known Limitations**

* No way to track services like `sssd` or `winbind`
* No support for creating/deploying custom profiles
