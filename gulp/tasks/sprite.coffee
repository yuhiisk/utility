gulp = require 'gulp'
config = require '../config'
$ = (require 'gulp-load-plugins')()

glob = require "glob"
_ = require "lodash"

createSpriteTask = (filePath) ->
    taskName = "sprite-#{filePath[2]}"
    gulp.task taskName, ->
        spriteData = gulp.src(filePath[1] + filePath[2] + '/*.png')
            .pipe($.plumber())
            .pipe($.spritesmith({
                imgName: filePath[2] + '.png',
                cssName: filePath[2] + '.scss',
                imgPath: '../img/' + filePath[2] + '.png'
                algorithm: 'binary-tree'
                padding: 4
            }))
        spriteData.img.pipe(gulp.dest(config.path.image))
        spriteData.css.pipe(gulp.dest(config.path.scss))
    return taskName

paths = glob.sync config.path.sprite + '**/*.png'

taskNames = _ paths
    .map (path) -> path.match(/^(.+\/)(.+?)(\/.+?\..+?)$/)
    .uniq (filePath) -> filePath[2]
    .map createSpriteTask
    .value()

gulp.task "sprite", taskNames
