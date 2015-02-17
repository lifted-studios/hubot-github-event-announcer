path = require 'path'

module.exports = (grunt) ->
  jasmine = './node_modules/jasmine-focused/bin/jasmine-focused'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffeelint:
      options: grunt.file.readJSON('coffeelint.json')
      src: ['src/*.coffee']
      spec: ['spec/*.coffee']

    shell:
      spec:
        command: "script/bootstrap && #{jasmine} --captureExceptions --coffee spec/"
        options:
          stdout: true
          stderr: true
          failOnError: true

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask('default', ['lint', 'spec'])
  grunt.registerTask('lint', ['coffeelint:src', 'coffeelint:spec'])
  grunt.registerTask('spec', ['shell:spec'])
