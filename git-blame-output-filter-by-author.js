#!env node

/**
 * https://github.com/mnmtanish/blamejs
 *
 * In scripts folder:
 * npm install --cli blamejs
 */
var BlameJS = require("blamejs");

/** npm install --cli lodash */
var _ = require('lodash');

/**
 * https://gist.github.com/polotek/977813
 * see pipe-input-test.js
 */
function readPipe(callback) {
  var TIMEOUT_MSEC=3000;

  var data = '';
  var timeout;

  process.stdin.resume();
  process.stdin.setEncoding('utf8');

  process.stdin.on('data', function(chunk) {
    data += chunk;
  });

  process.stdin.on('end', function() {
    if (timeout) {
      clearTimeout(timeout);
    }

    callback(data);
  });

  //setInterval(function() {
    //console.error('working');
  //}, 1e3);

  timeout = setTimeout(function() {
    console.error('Error! Pipe read timeout');
    process.exit(2)
  }, TIMEOUT_MSEC);
}

readPipe(function(pipeInput){
  var cliArgs = process.argv.slice(2);

  var author = cliArgs[0];

  if (!author) {
    console.log('author not set!');
    process.exit(1);
  }

  // without newline
  //process.stdout.write(pipeInput)

  //console.log(process.versions);

  var blamejs = new BlameJS();

  // Get the result of the git blame -p operation
  var blameOut = pipeInput;

  blamejs.parseBlame(blameOut);

  // Get the commit data
  var commitData = blamejs.getCommitData();

  // Get the line data array, each item containing a reference to
  // commits that can be then referenced in commitData
  var lineData = blamejs.getLineData();

  //var firstLine = commitData[lineData[0].hash];
  // firstLine now has:
  // - author
  // - authorMail
  // - authorTime
  // - authorTz
  // - committer
  // - committerMail
  // - committerTime
  // - committerTz
  // - summary
  // - previousHash
  // - filename

  //console.log(lineData)

  let result = [];

  _.forOwn(lineData, function(line, _number) {
    let hash = line.hash;

    //console.log(line)
    //console.log(commitData[hash])

    let info = commitData[hash];

    if (info.author == author) {
      result.push(line.code)
    }
  });

  console.log(result.join('\n'));

  process.exit();
});



