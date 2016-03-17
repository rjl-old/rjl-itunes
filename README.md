# Itunes 0.1

`Itunes` is a Ruby client for Apple's iTunes application. It's designed to support utilities that  make it both easier and more pleasant to maintain your collection of albums.

## Installation

    gem install rjl-itunes

## Usage

### Getting a list of albums

    require 'itunes'

    itunes = Itunes.new

    itunes.albums.each do |album|
        puts "#{album.artist}, '#{album.title}'"
        album.tracks.each do |track|
          puts track.title, track.genre
        end
    end

### Updating an album's genre

    album = itunes.albums[0]
    album.genre = "Pop/Rock"

See `/examples` for more uses. See 'Warning' below.

## How it works

`Itunes` uses applescript to interact with your currently active `Itunes` library. Albums and tracks can be manipulated in a straightforward manner. Playlists and Playlist Folders can be created and destroyed, and albums added to them.

### Tags

Tags can be used to control how `iTunes` interacts with your library. Tags are encoded as `[tag1][tag2]` in the track's `Groupings` field in iTunes (this is likely to change in future versions).

Reserved tags are as follows:

#### `[protected]`
Track is excluded from processing. Use this if, for example, you have set your own genre and do not want `Itunes` to change it.

## Warning

This might wreck your iTunes library in two ways. You might use commands that accidentally hose your library. Or the commands may have unknown side-effects. Always back up your library up first.

`Itunes` tries to be efficient in the way it interacts with iTunes, but Applescript is something of a dark art (to me). Expect scripts to mysteriously slow down, especially with large changes. [Ruby Progressbar](https://github.com/jfelchner/ruby-progressbar/wiki) is your friend.

## Changes

### 17 March 2016 -- 0.1
Initial release.

## Acknowledgements

`Itunes` uses [Brendan Thompson's Ruby fork](https://github.com/BrendanThompson/rb-scpt) of the SF Project [appscript](http://appscript.sourceforge.net/rb-appscript/index.html) for accessing itunes via applescript.

## Contacting me

You can contact me at r i c h l y o n @ m a c . c o m

## Copyright

Copyright (c) 2016 Richard Lyon. See LICENSE.txt for
further details.
