# Rjl_itunes 0.1

iTunes client for manipulating track metadata.

## Installation

    gem install rjl-itunes

## Usage

    require 'itunes'

    itunes = Itunes.new ITUNES_PATH

    itunes.albums.each do |album|
        puts "#{album.artist}, '#{album.title}'"
        album.tracks.each do |track|
            puts track.title
        end
    end

## How it works

`itunes` is a library for manipulating an iTunes library. It scans the iTunes Library XML file for album and track information.

### Tags

Tags can be used to control the library. Tags are encoded as [tag1][tag2] in the `Groupings` field. Reserved tags are as follows:

**[protected]** Track is excluded from processing. Use this if, for example, you have set your own genre and do not want `itunes`to change it.

## Warning

This might wreck your iTunes library.

## Changes

0.1 Reads the XML library and modifies file ID3 tags.

## Copyright

Copyright (c) 2016 Richard Lyon. See LICENSE.txt for
further details.
