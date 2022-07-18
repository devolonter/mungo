var gulp = require('gulp');
var svn2png = require('gulp-svg2png');
var merge = require('merge-stream');
var rename = require('gulp-rename');
var fs = require('fs');
var exec = require('child_process').execFile;
var path = require('path');

var POLY_HEIGHT = 1024;

function iconFactory(sizes, dest, callback) {
  var streams = [];

  sizes.forEach(function(size) {
    if (process.platform !== 'darwin') {
      var stream = gulp.src('./logo/poly.svg')
        .pipe(svn2png(size / POLY_HEIGHT))
        .pipe(rename(function (path) {
          path.basename += '-' + size + 'x' + size;
        }))
        .pipe(gulp.dest(dest));

      streams.push(stream);
    } else {
      for (var i = 0; i < 2; i++) {
        (function() {
          var suffix = '';
          var realSize = size;

          if (i === 1) {
            realSize = size * 2;
            suffix = '@2x';
          }

          var stream = gulp.src('./logo/poly.svg')
            .pipe(svn2png(realSize / POLY_HEIGHT))
            .pipe(rename(function (path) {
              path.basename = 'icon_' + size + 'x' + size + suffix;
            }))
            .pipe(gulp.dest(dest));

          streams.push(stream);
        })();
      }
    }
  });

  if (streams.length) {
    return merge.apply(this, streams);
  } else {
    callback();
    return null;
  }
}

function makeIco(iconsSet, dest, callback) {
  if (process.platform == 'win32') {
    var files = fs.readdirSync(iconsSet);
    files.push(dest);

    return exec('convert',
      files,
      {
        cwd: iconsSet
      },
      function (error, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);

        callback(error);
      }
    );
  } else if (process.platform == 'darwin') {
    return exec('iconutil',
      ['--convert', 'icns', iconsSet],

      function (error, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);

        callback(error);
      }
    );
  }
}

gulp.task('desktop', function(callback) {
  if (process.platform == 'win32') {
    return iconFactory([16, 32, 48, 96, 256], './.build/icons/' + process.platform, callback);
  } else if (process.platform == 'darwin') {
    return iconFactory([16, 32, 128, 256, 512], './.build/icons/' + process.platform + '.iconset', callback);
  } else {
    callback();
  }
});

gulp.task('web', function(callback) {
  return iconFactory([16, 32], './.build/icons/web', callback);
});


gulp.task('icon', ['desktop'], function(callback) {
  if (process.platform == 'win32') {
    return makeIco('./.build/icons/' + process.platform, '../mungo.ico', callback);
  } else if (process.platform == 'darwin') {
    return makeIco('./.build/icons/' + process.platform +'.iconset', 'mungo.icns', callback);
  } else {
    callback();
  }
});

gulp.task('favicon', ['web'], function(callback) {
  return makeIco('./.build/icons/web', '../favicon.ico', callback);
});

gulp.task('docs', function() {
  return gulp.src('./logo/poly.svg')
    .pipe(svn2png(32/POLY_HEIGHT))
    .pipe(rename('logo.png'))
    .pipe(gulp.dest('./.build/docs/'));
});

gulp.task('html5', function() {
  return gulp.src('./logo/poly.svg')
    .pipe(svn2png(512/POLY_HEIGHT))
    .pipe(rename('preloader.png'))
    .pipe(gulp.dest('./.build/html5/'));
});

gulp.task('default', ['icon', 'docs']);