module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    jekyll: {
      serve: {
        options: {
          serve: true,
          watch: true
        }
      },
      build: {
        options: {
          serve: false
        }
      }
    },

    uncss: {
      dist: {
        options: {
          ignore: [
            '.ui.accordion .accordion .active.content', 
            '.ui.accordion .active.content',
            '.ui.accordion .accordion .active.title .dropdown.icon',
            '.ui.accordion .active.title .dropdown.icon',
            '.ui.accordion.menu .item .active.title>.dropdown.icon'
          ],
          ignoreSheets: ["https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic&subset=latin"]
        },
        files: {
          'assets/css/main.css': ['_site/**/*.html']
        }
      }
    },

    uglify: {
      dist: {
        files: {
          'assets/js/js.js': [
            'src/semantic/semantic.js',
            'src/js/js.js'
          ]
        },
        options: {
          beautify: false,
          sourceMap: true,
          sourceMapIncludeSources: true
        }
      }
    },

    copy: {
      semantic: {
        files: [
          {
            expand: true,
            cwd: 'src/semantic/themes/',
            src: ['**/*'],
            dest: 'assets/css/themes/'
          }
        ]
      }
    },

    sass: {
      options: {
        includePaths: [
          'src/semantic/',
          'bower_components/pygments/css/'
        ],
        outputStyle: 'compressed',
        sourceMap: false
      },
      dist: {
        files: {
          'assets/css/main.css' : 'src/scss/main.scss'
        }
      }
    },

    watch: {
      sass: {
        files: 'src/scss/*.scss',
        tasks: ['sass']
      },
      js: {
        files: 'src/js/*.js',
        tasks: ['uglify']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');

  // JS
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // CSS
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-uncss');

  // Jekyll
  grunt.loadNpmTasks('grunt-jekyll');

  grunt.registerTask('default', ['uglify', 'copy', 'sass', 'jekyll:serve']);
  grunt.registerTask('production', ['uglify', 'copy', 'sass', 'jekyll:build']);
};
