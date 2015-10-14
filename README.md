# Bump

Bump versions with ease

## TODO

- support for `My::Application` with `--types=module::class` and/or `--init=module.My::class.App` (+ short variants `m` and `c`)
- enable `%a0` in pattern (`%a` is last element, `%A` is full form with `::`)
- support short and numeric forms for number arg `patch == 3 == r` (mnpr)
- mention `~/.bump` and `.bump` and their relation to Git root vs `--root`
- add installation / setup notes
- add basic usage documentation
- document options a bit more here
- document pattern formatting
- improve stderr
- add more tests

## Installation

```
gem 'bump', github: 'pavolzbell/bump'
```

## Usage

```
bin/bump -h
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request

## License

This software is released under the [MIT License](LICENSE.md)
