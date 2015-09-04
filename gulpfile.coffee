fs = require 'fs'
{spawn, exec} = require 'child_process'
gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
del = require 'del'
{log,colors} = require 'gulp-util'

# compile `index.coffee`
gulp.task 'coffee', (cb) ->
    cmd = exec 'npm run coffee', (err) ->
        return cb(err) if err
        cb()

# remove `index.js` and `coverage` dir
gulp.task 'clean', ->
    del ['index.js', 'coverage']

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# test drive
gulp.task 'selfie', ->
    usestrict = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(coffeelint [usestrict])
        .pipe(coffeelint.reporter())

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']
