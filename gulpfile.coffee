fs = require 'fs'
{spawn} = require 'child_process'
gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
del = require 'del'
{log,colors} = require 'gulp-util'

# compile `index.coffee`
gulp.task 'coffee', ->
    gulp.src('index.coffee')
        .pipe(coffee bare: true)
        .pipe(gulp.dest './')

# remove `index.js` and `coverage` dir
gulp.task 'clean', ->
    del ['index.js', 'coverage']

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# create changelog
gulp.task 'changelog', ->
    changelog = require 'conventional-changelog'
    changelog({
        repository: 'https://github.com/janraasch/coffeelint-use-strict'
        version: require('./package.json').version
    }, (err, log) ->
        fs.writeFileSync 'changelog.md', log
    )

# test drive
gulp.task 'selfie', ->
    usestrict = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(coffeelint [usestrict])
        .pipe(coffeelint.reporter())

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']
