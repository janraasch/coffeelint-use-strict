# coffeelint-use-strict [![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url] [![Dependency Status][depstat-image]][depstat-url] [![devDependency Status][devdepstat-image]][devdepstat-url]

> [CoffeeLint][coffeelint] rule that enforces usage of [strict mode][moz-strictmode-doc].

![example-output](screenshot.png)

## Usage

First, install `coffeelint-use-strict` globally:

```shell
npm install -g coffeelint-use-strict
```

Then, add a `"use_strict"` key with value `{"module": "coffeelint-use-strict"}` to your `coffeelint.json`, e.g.

```json
{
    "use_strict": {
        "module": "coffeelint-use-strict",
        "level": "error",
        "allowGlobal": false,
        "requireGlobal": false
    }
}
```

The `coffeelint` cli will then load this rule automatically. See the [documentation][coffeelint-api-doc] for other ways to make use of custom rules.

## Options

### level
Type: `String`
Default: `'error'`

The severity level of the violated rule. `level` must be one of `'ignore'`, `'warn'`, or `'error'`.

### allowGlobal
Type: `Boolean`
Default: `true`

Allow the `'use strict'` statement to be at the top of a file.

### requireGlobal
Type: `Boolean`
Default: `false`

Require the `'use strict'` statement to be at the top of a file.

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) © [Jan Raasch](http://janraasch.com)

[coffeelint]: http://www.coffeelint.org
[coffeelint-api-doc]: http://www.coffeelint.org/#api
[moz-strictmode-doc]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions_and_function_scope/Strict_mode?redirectlocale=en-US&redirectslug=JavaScript%2FReference%2FFunctions_and_function_scope%2FStrict_mode

[npm-url]: https://npmjs.org/package/coffeelint-use-strict
[npm-image]: https://badge.fury.io/js/coffeelint-use-strict.png

[travis-url]: http://travis-ci.org/janraasch/coffeelint-use-strict
[travis-image]: https://secure.travis-ci.org/janraasch/coffeelint-use-strict.png?branch=master

[coveralls-url]: https://coveralls.io/r/janraasch/coffeelint-use-strict
[coveralls-image]: https://coveralls.io/repos/janraasch/coffeelint-use-strict/badge.png

[depstat-url]: https://david-dm.org/janraasch/coffeelint-use-strict
[depstat-image]: https://david-dm.org/janraasch/coffeelint-use-strict.png

[devdepstat-url]: https://david-dm.org/janraasch/coffeelint-use-strict#info=devDependencies
[devdepstat-image]: https://david-dm.org/janraasch/coffeelint-use-strict/dev-status.png
