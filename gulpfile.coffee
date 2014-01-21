fs = require 'fs'
{spawn} = require 'child_process'
gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
clean = require 'gulp-clean'
{log,colors} = require 'gulp-util'

# compile `index.coffee`
gulp.task 'coffee', ->
    gulp.src('index.coffee')
        .pipe(coffee bare: true)
        .pipe(gulp.dest './')

# remove `index.js` and `coverage` dir
gulp.task 'clean', ->
    gulp.src(['index.js', 'coverage'], read: false)
        .pipe(clean())

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# create changelog
gulp.task 'changelog', ->
    changelog = require 'conventional-changelog'
    changelog({
        repository: 'https://github.com/janraasch/generator-gulpplugin-coffee'
        version: require('./package.json').version
    }, (err, log) ->
        fs.writeFileSync 'CHANGELOG.md', log
    )

# test drive
gulp.task 'selfie', ->
    usestrict = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(coffeelint null, false, [usestrict])
        .pipe(coffeelint.reporter())

# start workflow
gulp.task 'default', ->
    gulp.run 'coffee'

    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], (e) ->
        log "File #{e.type} #{colors.magenta e.path}"
        gulp.run 'test'

# Generated on 2014-01-20 using generator-gulpplugin-coffee 0.0.2
