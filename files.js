const fs = require('fs');

let dir = process.env.HOME + '/.musicp';
let file = dir + '/data.json';

let save = data => fs.writeFileSync(file, JSON.stringify(data));
let read = () => JSON.parse(fs.readFileSync(file));

let defaultConfig = {
  musics : [],
  config : {
    y2mp3 : 'mp3_multitube urls --ids',
    play : 'cmus-remote -f ',
    pause : 'cmus-remote -u'
  }
};

let bake = () => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
    fs.mkdirSync(dir + '/files');
    save(defaultConfig);
  }
};

module.exports = { dir, save, read, bake };
