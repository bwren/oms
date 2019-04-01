/*
 * Need:
 * - Compile css
 */


module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    // check all js files for errors
    jshint: {
      all: ['public/src/js/**/*.js', 'public/src/js/*.js']
    },

    // compile all scss to css
    sass: {
      dist: {
        files: {
          'public/dist/css/style.css': 'public/src/scss/style.scss',
          'public/dist/css/enhanced.css': 'public/src/scss/enhanced.scss'
        }
      }
    },

    // minify all js files into app.min.js
    uglify: {
      options: {
        mangle: false
      },
      build: {
        files: {
          'public/dist/js/app.min.js': ['public/src/js/**/*.js']
        }
      }
    },

    // configure mochaTest task
    /*mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          quiet: false, // default
          clearRequireCache: false // default
        },*/
    //src: ['tests/**/*.js']
    /*}
    },*/

    //configure grunt karma plugin
    karma: {
      unit: {
        configFile: 'karma.conf.js'
      }
    },

    // watch for changes to index.js
    nodemon: {
      dev: {
        script: 'index.js'
      }
    },

    // respond to changes to scripts and stylesheets
    watch: {
      sass: {
        files: 'public/src/scss/*.scss',
        tasks: ['sass']
      },
      scripts: {
        files: ['public/src/js/*.js', 'public/src/js/**/*.js'],
        tasks: ['uglify']
      },
      livereload: {
        files: ['public/dist/**/*.{css,js}', 'public/views/*.jade'],
        options: {
          livereload: true
        }
      }
    },

    // run watch and nodemon tasks concurrently
    concurrent: {
      dev: {
        options: {
          logConcurrentOutput: true,
        },
        tasks: ['watch', 'nodemon:dev']
      }
    }

  });

  // load tasks
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-karma');



  // register tasks on run grunt
  grunt.registerTask('default', [
    //'mochaTest',
    // 'jshint:all',
    'uglify',
    'sass:dist',
    'concurrent'
  ]);

};
