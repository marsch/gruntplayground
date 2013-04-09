module.exports = (grunt) ->
  'use strict'

  SRC_DIR = 'src'
  SPEC_DIR = 'spec'
  BUILD_TMP_DIR = 'tmp'
  BUILD_DIST = 'dist'
  BUILD_JS_SUB_PATH = 'js'
  BOWER_DIRECTORY = BUILD_TMP_DIR + '/vendor'

  _ = grunt.util._
  pkg = require './package.json'

  console.log pkg

  grunt.initConfig

    clean:
      bower: 'components'
      preprocess: BUILD_TMP_DIR + '/preprocessed'
      coffee: BUILD_TMP_DIR + '/js'
      amd: BUILD_TMP_DIR + '/js-amd'
      combine: BUILD_TMP_DIR + '/js-combined'
      minify: BUILD_TMP_DIR + '/js-minified'
      dist: BUILD_DIST
      tmp: BUILD_TMP_DIR

    copy:
      preprocess:
        files: [
          cwd: SRC_DIR
          dest: BUILD_TMP_DIR + '/preprocessed'
          expand: true
          src: [
            '**/*'
          ]
        ]

      static:
        files: [
          cwd: BUILD_TMP_DIR + '/preprocessed'
          dest: BUILD_TMP_DIR + '/js'
          expand: true
          src: [
            '**/*'
            '!**/*.coffee'
          ]
        ]

      assets:
        files: [
          cwd: SRC_DIR + '/assets'
          dest: BUILD_TMP_DIR + '/final/'
          expand: true
          src: [
            '**/*'
          ]
        ]

      dist:
        files: [
          cwd: BUILD_TMP_DIR + '/final'
          dest: BUILD_DIST
          expand: true
          src: [
            '**/*'
          ]
        ]

    compass:
      compile:
        src: BUILD_TMP_DIR + '/js-amd/css/'
        dest: BUILD_TMP_DIR + '/final/css'
        outputStyle: 'expanded'
        environment: 'development'


    preprocess:
      coffee:
        src: [BUILD_TMP_DIR + '/preprocessed/**/*.coffee']
        options:
          inline: true
          context: {
            VERSION: pkg.version
            APP_NAME: pkg.name
            DEBUG: true
          }
      js:
        src: [BUILD_TMP_DIR + '/preprocessed/**/*.js']
        options:
          inline: true
          context: {
            VERSION: pkg.version
            DEBUG: true
          }

      templates:
        files: [
          expand: true
          src: [BUILD_TMP_DIR + '/preprocessed/**/*.mustache.html']
          # rename it - so template can be processed to js
          ext: '.mustache'
        ]
        options:
          inline: true
          context: {
            VERSION: pkg.version
          }


    coffee:
      compile:
        options:
          bare: true
        files: [
          expand: true
          cwd: BUILD_TMP_DIR + '/preprocessed/'
          src: '**/*.coffee'
          dest: BUILD_TMP_DIR + '/js'
          ext: '.js'
        ]
      spec:
        options:
          bare: true
        files: [
          expand: true
          cwd: SPEC_DIR
          src: '**/*.coffee'
          dest: BUILD_TMP_DIR + '/js-spec'
          ext: '.js'
        ]

    # Module conversion
    # -----------------
    urequire:
      convert:
        template: 'AMD'
        bundlePath: BUILD_TMP_DIR + '/js/'
        outputPath: BUILD_TMP_DIR + '/js-amd/'
        options:
          relativeType: 'bundle'

    bower:
      install:
        options:
          targetDir: BOWER_DIRECTORY
          cleanup: true
          install: true

    requirejs:
      compile:
        options:
          out: BUILD_TMP_DIR + '/final/' + BUILD_JS_SUB_PATH + '/main.js'
          include: _(grunt.file.expandMapping(['app*.js', 'controllers/**/*.js'], ''
            cwd: BUILD_TMP_DIR + '/js-amd/'
            rename: (base, path) -> path.replace /\.js$/, ''
          )).pluck 'dest'
          mainConfigFile: BUILD_TMP_DIR + '/js/main.js'
          baseUrl: BUILD_TMP_DIR + '/js-amd/'
          keepBuildDir: true
          almond: true
          optimize: 'none'

    mustache:
      templates:
        src: BUILD_TMP_DIR + '/preprocessed/templates'
        dest: BUILD_TMP_DIR + '/js/templates.js'
        options: {
          prefix: 'module.exports = '
          postfix: ';'
          verbose: true
        }

    jasmine:
      src: '/*.js'
      options:
        outfile: './_SpecRunner.html'
        specs: BUILD_TMP_DIR + '/js-spec/**Spec.js'
        helper: BUILD_TMP_DIR + '/js-spec/*Helper.js'
        template: require('grunt-template-jasmine-requirejs')
        templateOptions:
          requireConfig:
            baseUrl: BUILD_TMP_DIR + '/tmp/final/js'
            paths:
              depend: 'tmp/js-amd/lib/require-depend'
              underscore: 'tmp/js-amd/vendor/underscore'
              jquery: 'tmp/js-amd/vendor/jquery'
              backbone: 'tmp/js-amd/vendor/backbone'
              mustache: 'tmp/vendor/js/mustache/mustache'
              chaplin: 'tmp/vendor/js/chaplin/chaplin'



  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    console.log 'load' + name
    grunt.loadNpmTasks name

  grunt.registerTask 'prepare', [
    'bower:install'
    'clean:bower'
  ]


  grunt.registerTask 'script', [
    'copy:preprocess'
    'preprocess'
    'coffee:compile'
    'copy:static'
  ]

  grunt.registerTask 'build', [
    'script'
    'mustache'
    'urequire:convert'
    'copy:assets'
    'requirejs:compile'
    'compass:compile'
    'copy:dist'
  ]

  grunt.registerTask 'test', [
    'script'
    'mustache'
    'urequire:convert'
    'coffee:spec'
    'jasmine'
  ]




