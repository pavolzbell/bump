general

- document options a bit more here
- document pattern formatting
- document `#` flag for pattern formatting
- document each feature with examples

- improve stderr
- add more tests
- also test short options

0.4.0

- consider renaming `--root` to `--target`
- consider `--init arg` instead of `--init=opt`
- consider changing `--init=<word[:word]>` to `--init [<path>] <app>` as `bump --init my/app My::App` 
- consider changing `--repo=<repository>` to `--repo[sitory]=<repository>` although git uses just `--repo`

- add `--sync` as alias for both `--pull` and `--push`
- add `--author` for commit author (or add `--commit` for custom commit args? similar for tag, push, pull ...)

- rename `--silent` to `--interactive` (alias as `-i`), on by default
- introduce `--[no]-verbose` off meaning no stdout of ext commands (stderr of ext commands still going), on by default
- introduce `--silent` as no stdout and stderr at all, off by default

- note to add `require File.expand_path('../version', __FILE__)` to Rails `config/application.rb`

0.5.0

- support hierarchical gems / rails engines
- support for `My::Application` with `--types=module::class` and/or `--init=module.My::class.App` (+ short variants `m` and `c`)
- enable `/%#?(-?\d*)a/` in pattern, where: `%0a` is first element, `%-1a` is last element, `%a` is full form with `::`
- enable `/%#?(-?\d*)v/`, `%1v` and `%#-1v` for 1.2.3.alpha` resolves as `2` and `'alpha'` 
- `%#a` should expand to `module Target; %% end` so target schema for gem should change from `module %a; VERSION = %#v; end` just to `%#a; VERSION = %#v`
- support numerical bump args, leading zeros: 0 -> major, 1 -> minor, ...

0.6.0

- distinguish between `--target-schema` (file hierarchy and content) and `--version-schema` (1.0.0.alpha vs 1.0.0-alpha)
- retain `--schema=<target-schema>[:<version-schema>]`
- extract code of target and version schemas to lib as modules / classes
- make rubysemver gem, see https://github.com/search?utf8=%E2%9C%93&q=semver+ruby&type=Repositories&ref=searchresults

- support target schemas with default version schemas: gem[:semver], rails[:semver]
- support version schemas: gem, rails, semver

- for gem version schema use Gem::Version, cut build, see https://github.com/rubygems/rubygems/blob/master/lib/rubygems/version.rb
- for rails version schema use Gem::Version, cut build and limit it to 3-4 segments, see https://github.com/rails/rails/blob/master/version.rb
- for semver version schema use rubysemver gem

- target schema + version schema at 1.2.3-rc1+build.123
  gem   + gem    -> `my_gem/version.rb` : `module MyGem; VERSION = '1.2.3.rc1'; end`
  gem   + rails  -> `my_gem/version.rb` : `module MyGem; VERSION = '1.2.3.rc1'; end`
  gem   + semver -> `my_gem/version.rb` : `module MyGem; VERSION = '1.2.3-rc1+build.123'; end`
  rails + gem    -> `config/version.rb` : `module MyApp; module VERSION; STRING = '1.2.3.rc1'; end; end`
  rails + rails  -> `config/version.rb` : `module MyApp; module VERSION; MAJOR = 1; MINOR = 2; TINY = 3; PRE = 'rc1'; STRING = [MAJOR, MINOR, TINY, PRE].compact * '.'; end; end`
  rails + semver -> `config/version.rb` : `module MyApp; module VERSION; MAJOR = 1; MINOR = 2; PATCH = 3; PRE = 'rc1'; BUILD = 'build.123'; STRING = X; end; end`
    where X is: `[[[MAJOR, MINOR, PATCH] * '.', PRE].compact * '-', BUILD].compact * '+'`
                `[MAJOR, MINOR, PATCH] * '.' << ('-' + PRE if PRE) << ('+' + BUILD if BUILD)`

- in ruby code always store numeric version segments as numbers and empty strings as nils 

- SemVer actually prefers `2.0.0-alpha.1` to `2.0.0.alpha.1`, bump should support both notations, `--version-schema=(rails|semver)`
- SemVer also supports `+` sign: `1.0.0-beta+20130313144700`, introduce `--build`
- SemVer states that pre-release can contain dots: `alpha.1.2.3+build-2.0`
- Semver version schema uses `-` instead of `.` as pre-release separator

- consider `--build` as an addition to `--pre`
- validate version strings / data / segments according to version schemas:
  gem or rails via regexps in Gem::Version
  rubysemver via SemVer:
    version -> `maj.min.pat(-pre)?(+build)?`
    maj|min|pat -> `\d+` no leading zeros (`0.0.0` is ok, but `00.00.00` is not)
    pre|build -> non-empty identifiers sep with `.`
    identifier -> `[0-9A-Za-z-]` no leading zeros for numeric identifiers
    see https://github.com/mojombo/semver/blob/master/semver.md#backusnaur-form-grammar-for-valid-semver-versions
    see https://github.com/mojombo/semver/issues/279#issuecomment-153387572

ideas

- `--reverse` bumps `1.2.3` to `1.2.2`, `--reverse minor` bumps `1.2.3` to `1.1.0`
- `--inc[rement] minor` bumps `1.2.3` to `1.3.3`
- `--dec[rement] minor` bumps `1.2.3` to `1.1.3`
- support for both custom `--target-schema` and `--version-schema` via loading Ruby code or via a lot of options
- support more than 3-4 version numbers, should last be always reserved for pre-release / metadata?
- `--[no]-version-leading-zeros`, `--[no]-version-trailing-zeros`
- `--version-segment-separator=`, `--version-pre-release-separator=`, `--version-build-separator=`
- `--version-format=` -> `%m.%n.%p-%r+b` or `%0v.%1v.%2v-%3v` used to format version data array to version string
- `--version-regexp=` -> `(\d+).(\d+).(\d+)` used to parse (and validate) version string (dynamically loaded to constant / variable or grepped from file) to version data array
- `--target-format=` -> `%#a; VERSION = %#v; MAJOR = %#m` (note that `--file` is `--target-file`)
