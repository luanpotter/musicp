# musicp

`musicp` is a simple music manager CLI that allows you to easily acquire (via youtube), organize and play your favorite musics.  

## Requirements

You need two things to use this: a music player and a youtube downloader.  
This is ready to work out of the box with [cmus](https://cmus.github.io) and [mp3_multitube](https://github.com/bieelsoares/mp3_multitube).  
You also need a Youtube API Key.  
Finally, clone this project and run `npm install`.  

### cmus

Download `cmus` from [their website](https://cmus.github.io/#download).  
It should come with `cmus-remote` (that's required for `musicp`!).  
Extract and add to the path as `cmus` and `cmus-remote`.  

### mp3_multitube

Follow [their instructions](https://github.com/bieelsoares/mp3_multitube).  
You will end up exporting `mp3_multitube` to the PATH.  

### API Key

Follow [this tutorial](http://help.dimsemenov.com/kb/wordpress-royalslider-tutorials/wp-how-to-get-youtube-api-key) to get one.  

### Custom helpers

You can use different helpers (music player and youtube downloader) if you so desire.  
For that, you need to first run the program so your `.musicp` folder will be downloaded and setup properly.  
Then, you can edit the `data.json` config file and change the following keys, in order to use your own stuff:

```
	"config" : {
	    "y2mp3" : "mp3_multitube urls --ids", // a temporary `url` file is created in the current dir
	    "play" : "cmus-remote -f ", // the full mp3 file path is added to the end
	    "resume" : "cmus-remote -p", // resume from where it was paused
	    "pause" : "cmus-remote -u", // pauses
	    "status":"cmus-remote -Q"`// must return in the cmus format, but you can map yours with bash
	}
```

## Usage

Run `cmus` in another shell. Leave it on non-repeat (not 'C') and running, so `cmus-remote` can access it.  
Run musicp (`node index.js`) and use the commands to control your player.  
First time running, it will create a `.musicp` folder in your home. All `mp3`s and a `data.json` config file will be stored there.  
Run `key <youtube_api_key>` first.  

Then you can:

  * query query string... : query youtube and list the results
  * add [list index or id] : add a youtube video to your musics
  * musics : list your musics
  * update : download any new musics (they are red in `musics`)
  * play [list index or id] : play a music in cmus
  * pause : pause current playing song
  * resume : resumes playing current song from where it stopped
  * status : see what's playing and the status
  * tag [list index or id] tag1 tag2... : tags the selected music with those tags
  * tags : list all tags added so far
  * tags <tag> : list musics with that given tag
  * find query string... : find in your musics musics that match query string in id or title (full text search, but need to be worked out further)
  * shuffle : starts playing a random song from the current list and keeps playing on shuffle from that list

An important note: commands like `musics`, `find`, `tags <tag>` will set the current list. Commands like `play <list index>` or `shuffle` consider only the current list.  
`query` will also reset the list, but the list it sets can only be indexed by `add`. Therefore, be carefull while `query`ing while `shuffl`ing - it gets messy.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D