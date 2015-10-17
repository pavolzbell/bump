# Bump

[![Build Status](https://travis-ci.org/pavolzbell/bump.svg)](https://travis-ci.org/pavolzbell/bump)

Bump versions of Ruby gems and Rails applications with ease according to [Semantic Versioning](http://semver.org)

#### What does Bump do?

1. Pulls recent changes
2. Bumps version number
3. Commits and tags it
4. Pushes bump changes

## Installation

Add to line to your `Gemfile`

    gem 'bump', github: 'pavolzbell/bump'

And then execute

    bundle install

#### Setup

Execute with `init` option to generate necessary files

    bundle exec bump --init=my_gem:MyGem --schema=gem

This creates these files without overwriting existing ones

    .bump
    bin/bump
    lib/my_gem/version.rb

Your gem version file should look like this

    module MyGem
      VERSION = '0.0.0'
    end

## Usage

Execute via `bin/bump` or `bundle exec bump`

For a complete list of options see `bump -h`

#### Configuration

Bump script relies on specific `.bump` files hierarchy when parsing options

    ~/.bump
    .bump
    --root=target/.bump

Options from each `.bump` file are overridden by the latter and finally by the direct command line options

Note that specifying `--root` option in several bump files and/or command line may lead to unexpected behavior 

#### Syntax

Format options as `-o`, `-ox`, `-o x`, `--opt`, `--opt x` or `--opt=x`

#### Releasing

In general bump does the following

1. Pulls recent changes from specified branches and synchronizes them
2. Increases the desired version number according to the target schema
3. Creates custom bump commit and tags it by default with custom name
4. Synchronizes specified branches again and pushes latest bump changes 

Each step can be adjusted via various options listed below some examples

Bump script accepts several options and only one optional argument which denotes the desired version to bump 

- `m` or `major`
- `n` or `minor`
- `p` or `patch` which is the default
- `r` or `pre`

Let there be a target gem with name `MyGem` and version number pinned to `1.2.3.rc0` for each of the following examples 

Bump patch version to `1.2.4.rc0`

    bump

Release major version to `1.0.0`

    bump -r m
    
Bump minor version to `1.3.0.rc1` and do not tag the bump commit 

    bump --no-tag minor

Release major version to `1.0.0` with custom commit and tag name

    bump -m 'Bump %a to %v' -n '%v' -r m

Pull recent changes but do not push them to remote repository, also do not tag and bump to `1.3.0.rc1` 

    bump --pull --no-push --no-tag --repo=target --pre=rc1 minor

#### Pre-releasing

List of pre-release options

- `release` - enables or disables ignoring of the `pre` option, disabled by default
- `pre` – sets the pre-release label, unset by default

#### Schemas

Currently supported target schemas are `gem` and `rails`

List of schema related options

- `init` – sets path to version file and target name in format `path:name`
- `schema` – sets target version schema, set to `gem` by default

Note that nested modules or classes such as `My::Gem` are currently not supported

#### Git

List of Git related options

- `branches` – sets a list of comma separated branches to pull, checkout and push, set to `master` by default
- `message` – sets bump commit message pattern, set to `Bump version to %v` by default
- `name` – sets bump tag name pattern, set to `v%v` by default
- `tag` – enables or disables tagging of the bump commit, enabled by default
- `repo` – sets target Git sync repository, set to `origin` by default
- `pull` – enables or disables pulling latest changes to the specified branches of Git sync repository, enabled by default
- `push` – enables or disables pushing bump changes to the specified branches of Git sync repository, enabled by default

For `MyGem` target at version `1.2.3.rc0` commit message and tag name pattern maps

- `%a` to target name `MyGem`
- `%m` to major version `1`
- `%n` to minor version `2`
- `%p` to patch version `3`
- `%r` to additional label `rc0`
- `%v` to version number `1.2.3.rc0`

#### Paths

List of path related options

- `root` – sets the target root directory, exists to support bumping of nested targets from base Git repository, current working directory by default
- `file` – sets both version file input and output, an alias for both `input` and `output` 
- `input` – sets version file input, default value depends on schema
- `output` – sets version file output, default value depends on schema

Paths can be set as absolute paths or paths relative to `root` directory or to the current working directory in case of the `root` option

#### Other

List of other options

- `silent` – enables or disables key confirmation before any actual changes, enabled by default
- `help` – prints help and exits

## Testing

    bundle exec rspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request

## License

This software is released under the [MIT License](LICENSE.md)
