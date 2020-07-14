#!env node

// https://gist.github.com/polotek/977813
function readPipe(callback) {
  var TIMEOUT_MSEC=3000;

  var data = '';

  process.stdin.resume();
  process.stdin.setEncoding('utf8');

  process.stdin.on('data', function(chunk) {
    data += chunk;
  });

  process.stdin.on('end', function() {
    callback(data);
  });

  //setInterval(function() {
    //console.error('working');
  //}, 1e3);


  setInterval(function() {
    console.error('Error! Pipe read timeout');
    process.exit(2)
  }, TIMEOUT_MSEC);
}

readPipe(function(data){
    // https://stackoverflow.com/questions/16369642/javascript-how-to-use-a-regular-expression-to-remove-blank-lines-from-a-string

    //console.log(JSON.stringify(rawData));

    //let data = rawData.replace(/^[\s\t]*(\r\n|\n|\r)/gm, '')

  //console.log(JSON.stringify(data));

    //console.log('1')
    // without newline
    process.stdout.write(data)
    //console.log('')
    process.exit();
});
