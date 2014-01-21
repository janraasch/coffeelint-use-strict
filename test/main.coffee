# module dependencies
fs = require 'fs'
should = require 'should'
CoffeeScript = require 'coffee-script'

# SUT
Rule = require '../'

getFixtureAST = (fixture) ->
    file = "#{__dirname}/fixtures/#{fixture}.coffee"
    source = fs.readFileSync(file).toString()
    CoffeeScript.nodes source

describe 'coffeelint-use-strict', ->
    rule = null

    beforeEach ->
        rule = new Rule()
        rule.errors = []

    describe 'no matter what', ->
        astApi = {}

        beforeEach ->
            astApi =
                config: use_strict: {}
                createError: (e) -> e

        it 'it passes through empty files', ->
            rule.lintAST CoffeeScript.nodes(''), astApi
            rule.errors.should.have.length 0

        it 'it passes through empty functions', ->
            rule.lintAST CoffeeScript.nodes('->'), astApi
            rule.errors.should.have.length 0

    describe 'requires global use strict', ->
        astApi = {}

        beforeEach ->
            astApi =
                config: use_strict: requireGlobal: true
                createError: (e) -> e

        it 'if the option is set', ->
            rule.lintAST getFixtureAST('class-global'), astApi
            rule.errors.should.have.length 0
            rule.lintAST getFixtureAST('class-strict'), astApi
            rule.errors.should.have.length 1
            rule.errors[0].should.have.property 'lineNumber'
            rule.errors[0].lineNumber.should.equal 2

    describe 'allows use strict on top of file', ->
        astApi = {}

        beforeEach ->
            astApi =
                config: use_strict: allowGlobal: true
                createError: (e) -> e

        it 'if the allowGlobal is true', ->
            rule.lintAST getFixtureAST('class-global'), astApi
            rule.errors.should.have.length 0
            rule.lintAST getFixtureAST('class-strict'), astApi
            rule.errors.should.have.length 0

        it 'but use strict at bottom is not enough', ->
            rule.lintAST getFixtureAST('code-bottom'), astApi
            rule.errors.should.have.length 1
            rule.errors[0].should.have.property 'lineNumber'
            rule.errors[0].lineNumber.should.equal 1

    describe 'does not allow use strict on top of a file', ->
        astApi = {}

        beforeEach ->
            astApi =
                config: use_strict: allowGlobal: false
                createError: (e) -> e

        it 'if the allowGlobal is false', ->
            rule.lintAST getFixtureAST('class-global'), astApi
            rule.errors.should.have.length 4
            rule.errors[0].should.have.property 'lineNumber'
            rule.errors[0].lineNumber.should.equal 4
            rule.errors[0].should.have.property 'message'
            rule.errors[0].message.should.equal "'use strict' at top of file"
            rule.errors[1].should.have.property 'lineNumber'
            rule.errors[1].lineNumber.should.equal 7
            rule.errors[2].should.have.property 'lineNumber'
            rule.errors[2].lineNumber.should.equal 10
            rule.errors[3].should.have.property 'lineNumber'
            rule.errors[3].lineNumber.should.equal 12

    describe 'checks for local (function scope) use strict', ->
        astApi = {}

        beforeEach ->
            astApi =
                config: use_strict: {}
                createError: (e) -> e

        it 'by default', ->
            rule.lintAST getFixtureAST('code-mixed'), astApi
            rule.errors.should.have.length 1
            rule.errors[0].should.have.property 'lineNumber'
            rule.errors[0].lineNumber.should.equal 5
