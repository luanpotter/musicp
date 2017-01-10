const co = require('co');
const prompt = require('co-prompt');
const Spinner = require('cli-spinner').Spinner;

let spinner = new Spinner('%s');
spinner.setSpinnerString('|/-\\');
spinner.setSpinnerDelay(200);

let cli = function (processor) {
  return { start : () => {
    co(function *() {
      while (true) {
        let name = yield prompt('> ');
        spinner.start();
        let res = yield processor(name);
        spinner.stop(true);
        console.log(res);
      }
    });
  }};
};

module.exports = cli;
