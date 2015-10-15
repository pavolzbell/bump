# Bump

[![Build Status](https://travis-ci.org/pavolzbell/bump.svg)](https://travis-ci.org/pavolzbell/bump)

Bump versions with ease

## TODO

- support for `My::Application` with `--types=module::class` and/or `--init=module.My::class.App` (+ short variants `m` and `c`)
- enable `%a0` in pattern (`%a` is last element, `%A` is full form with `::`)
- add `--author` for commit author (or add `--commit` for custom commit args? similar for tag, ...)
- mention `~/.bump` and `.bump` and their relation to Git root vs `--root`
- add installation / setup notes
- add basic usage documentation
- document options a bit more here
- document pattern formatting
- improve stderr
- test also short options
- add more tests

## Installation

```
gem 'bump', github: 'pavolzbell/bump'
```

#### Setup

```
bundle exec bump --init=MyGem --schema=gem
```

## Usage

```
bin/bump -h
```

#### Syntax

Format options as `-o`, `-ox`, `-o x`, `--opt`, `--opt x` or `--opt=x`

## Testing

```
bundle exec rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request

## License

This software is released under the [MIT License](LICENSE.md)
