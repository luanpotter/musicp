const fs = require('fs');
const _ = require('lodash');
const Youtube = require('youtube-node');
const exec = require('child_process').execSync;

let dir = process.env.HOME + '/.musicp';
let youtube = new Youtube();

let y2mp3 = 'mp3_multitube';
let cmus = {
  play : 'cmus-remote -f ' + dir + '/files/',
  pause : 'cmus-remote -u'
}

let bake = () => {
  if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
    fs.mkdirSync(dir + '/files');
    save({ musics : [] });
  }
};

let file = dir + '/data.json';
let save = data => fs.writeFileSync(file, JSON.stringify(data));
let read = () => JSON.parse(fs.readFileSync(file));

let data;
let lastSearch;

let main = () => {
  bake();
  data = read();
  youtube.setKey(data.youtubeKey);
  register();
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
  console.log(id);
  youtube.getById(id, function(error, result) {
    if (error) {
      console.log(error);
    } else {
      cb(videoMapper(result.items[0]));
    }
  });
};

let CMDS = {
  exit : () => process.exit(0),
  see : () => console.log(JSON.stringify(data)),
  add : cmds => fetch(select(cmds[0]), d => data.musics.push(d)),
  key : cmds => {
    data.youtubeKey = cmds[0];
    youtube.setKey(cmds[0]);
  },
  query : cmds => youtube.search(cmds.join(' '), 5, function(error, result) {
    if (error) {
      console.log('You need to set your key, use key [key].');
    } else {
      lastSearch = result.items.map(videoMapper);
      console.log(lastSearch.map((r, i) => '[' + i + '] ' + r.name).join('\n'));
    }
  }),
  musics : () => {
    lastSearch = data.musics;
    console.log(data.musics.map((m, i) => '[' + i + '] ' + m.id + ' - ' + m.name).join('\n'));
  },
  remove : cmds => {
    let id = select(cmds[0]);
    data.musics = data.musics.filter(r => r.id !== id);
  },
  update : () => {
    let ids = data.musics.map(d => d.id).filter(id => {
      let path = dir + '/files/' + id + '.mp3';
      return !fs.existsSync(path);
    }).join('\n');
    fs.writeFileSync(dir + '/files/urls', ids);
    exec('( cd ' + dir + '/files ; ' + y2mp3 + ' urls )', execCb);
    fs.unlinkSync(dir + '/files/urls');
  },
  play : cmds => exec(cmus.play + select(cmds[0]) + '.mp3', execCb),
  pause : () => exec(cmus.pause, execCb)
};

let parse = cmd => {
  let notFound = () => console.log('Command not found.');
  let p = CMDS[cmd[0]] || notFound;
  p(cmd.slice(1));
  save(data);
};

let register = () => {
  let stdin = process.openStdin();
  stdin.addListener('data', d => parse(d.toString().trim().split(' ')));
};

main();
