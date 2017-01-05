const fs = require('fs');
const _ = require('lodash');
const Youtube = require('youtube-node');
const exec = require('child_process').exec;
const wait = require('wait.for-es6');
const chalk = require('chalk');

const files = require('./files');
const cli = require('./cli');

let youtube = new Youtube();

let data;
let lastSearch;

let main = () => {
  files.bake();
  data = files.read();
  youtube.setKey(data.youtubeKey);
  r.start();
};

function isPositiveInteger(n) {
    return n >>> 0 === parseFloat(n);
}

let select = indexOrId => {
  if (isPositiveInteger(indexOrId)) {
    return lastSearch[parseInt(indexOrId)].id;
  }
  return indexOrId;
};

let execCb = function (error, stdout, stderr) {
  console.log('stdout: ' + stdout);
  console.log('stderr: ' + stderr);
  if (error !== null) {
    console.log('exec error: ' + error);
  }
};

let videoMapper = r => ({ id : _.isString(r.id) ? r.id : r.id.videoId, name : r.snippet.title });

let fetch = (id, cb) => {
  youtube.getById(id, function(error, result) {
    if (error) {
      console.log(error);
    } else {
      cb(videoMapper(result.items[0]));
    }
  });
};

let findBy = (r, fn) => {
  lastSearch = data.musics.filter(fn);
  r(lastSearch.map((m, i) => chalk[files.hasMusic(m.id) ? 'white' : 'red']('[' + i + '] ' + m.id + ' - ' + m.name)).join('\n'));
};

let CMDS = {
  exit : () => process.exit(0),
  see : r => r(JSON.stringify(data)),
  add : (r, cmds) => {
    fetch(select(cmds[0]), d => {
      data.musics.push(d);
      r(chalk.green('Added ' + d.name));
    });
  },
  key : (r, cmds) => {
    data.youtubeKey = cmds[0];
    youtube.setKey(cmds[0]);
    r(chalk.green('Key set'));
  },
  query : (r, cmds) => {
    youtube.search(cmds.join(' '), 5, function(error, result) {
      if (error) {
        r(chalk.red('You need to set your key, use key [key].'));
      } else {
        lastSearch = result.items.map(videoMapper);
        r(lastSearch.map((r, i) => '[' + i + '] ' + r.name).join('\n'));
      }
    });
  },
  musics : r => {
    findBy(r, _.identity);
  },
  find : (r, cmds) => {
    findBy(r, m => _.intersection((m.id + ' ' + m.name).toLowerCase().split(' '), cmds.map(e => e.toLowerCase())).length > 0);
  },
  remove : (r, cmds) => {
    let id = select(cmds[0]);
    data.musics = data.musics.filter(r => r.id !== id);
    r(chalk.green('Removed'));
  },
  update : r => {
    let ids = data.musics.map(d => d.id).filter(id => !files.hasMusic(id));
    let download = function*() {
      yield wait.for(fs.writeFile, files.dir + '/files/urls', ids.join('\n'));
      yield wait.for(exec, '( cd ' + files.dir + '/files ; ' + data.config.y2mp3 + ' )');
      yield wait.for(fs.unlink, files.dir + '/files/urls');
      r(chalk.green('Updated'));
    };
    if (ids.length === 0) {
      r(chalk.blue('Nothing to update!'));
    } else {
      wait.launchFiber(download);
    }
  },
  play : (r, cmds) => {
    function *t() {
      yield wait.for(exec, data.config.play + files.dir + '/files/' + select(cmds[0]) + '.mp3');
      r(chalk.green('Playing'));
    }
    wait.launchFiber(t);
  },
  pause : r => {
    function *t() {
      yield wait.for(exec, data.config.pause);
      r(chalk.green('Paused'));
    }
    wait.launchFiber(t);
  }
};

let parse = function*(str) {
  let cmd = str.trim().split(' ');
  let notFound = (r) => r('Command not found.');
  let fn = CMDS[cmd[0]] || notFound;
  let promise = new Promise(r => fn(r, cmd.slice(1)));
  promise.then(() => files.save(data));
  return promise;
};

let r = cli(parse);

main();
