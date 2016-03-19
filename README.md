# rjl-itunes 0.1

`rjl-itunes` is a Ruby client for Apple's iTunes application. It's designed to support utilities that  make it both easier and more pleasant to maintain your collection of albums.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rjl-itunes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rjl-itunes

## Usage

### Getting a list of albums

    require 'rjl/itunes'

    itunes = RJL::Itunes.new

    itunes.albums.each do |album|
        puts "#{album.album_artist}, '#{album.title}'"
        album.tracks.each do |track|
          puts track.title, track.genre
        end
    end

### Updating an album's genre

    album = itunes.albums[0]
    album.genre = "Pop/Rock"

See `/bin` for more uses. See 'Warning' below.

## How it works

`rjl-itunes` uses applescript to interact with your currently active Itunes library. Albums can be manipulated in a straightforward manner. Playlists and Playlist Folders can be created and destroyed, and albums added to them.

### Genres

Album genres are sometimes divided into sub-genres. [Allmusic.com](allmusic.com) refers to these sub-genres as 'styles', and can return several genres and styles for an album. iTunes provides the field `genre` for specifying genre and allows albums to be sorted by this field in the 'Albums' view. It also provides the field `grouping`, but only allows albums to be sorted by this via the column Browser in the 'Songs' view. There is no straightforward way of mapping multiple genres and styles into this these fields.

`rjl-itunes` computes a single string to represents the album's genre from the genres and styles obtained from [Allmusic.com](allmusic.com). The frequency of each genre and style in the whole library is calculated. For each album that has more than one genre or style, the highest frequency genre and style is chosen and combined.

### Tags

Tags can be used to control how `rjl-itunes` interacts with your library. Tags are encoded as `[tag1][tag2]` in the track's `groupings` field in iTunes (this is likely to change in future versions).

Reserved tags are as follows:

* `[protected]`
Track is excluded from processing. Use this if, for example, you have set your own genre and do not want `rjl-itunes` to change it.

## Warning

This might wreck your iTunes library in two ways. You might use commands that accidentally hose your library. Or the commands may have unknown side-effects. Always back up your library up first.

`rjl-itunes` tries to be efficient in the way it interacts with iTunes, but Applescript is something of a dark art (to me). Expect scripts to mysteriously slow down, especially with large changes. [Ruby Progressbar](https://github.com/jfelchner/ruby-progressbar/wiki) is your friend.

## Testing

RSpec tests are provided. The tests will not work with your library, but I can't distribute mine because of copyright issues. You can edit the tests to suit your own library.

## Changes

### 17 March 2016 -- 0.1
Initial release.

## Acknowledgements

`rjl-itunes` uses [Brendan Thompson's Ruby fork](https://github.com/BrendanThompson/rb-scpt) of the SF Project [appscript](http://appscript.sourceforge.net/rb-appscript/index.html) for accessing itunes via applescript.

## Contacting me

You can contact me at r i c h l y o n @ m a c . c o m

## Copyright

Copyright (c) 2016 Richard Lyon. See {file:LICENSE.txt LICENSE} for
further details.
