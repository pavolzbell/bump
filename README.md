# Bump

Bump versions with ease

## TODO

- add `bump --generate=A --schema=S` or `bump --schema=S A` 
  - requires `--schema`
  - creates `.bump`
  - creates `bin/bump`
  - creates `lib/sample/version.rb` or `config/version.rb`
  - should also check and fix gemspec
  - fails on or ignores other irrelevant options?
- change default schema to `gem`
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
