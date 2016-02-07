#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist' # https://github.com/bleything/plist

class Itunes

  attr_reader :albums

  ITUNES_PATH = '/Users/richlyon/Music/iTunes/iTunes Music Library.xml'
  LIVE = '/Users/richlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  attr_reader :itunes_path

  def initialize( itunes_path = ITUNES_PATH )
    @itunes_path = itunes_path
    @itunes_plist = Plist::parse_xml( ITUNES_PATH )
    @albums = get_albums
  end

  def valid?
    return !@itunes_plist.nil?
  end

  def get_albums
    album = {
      "artist" => "ABBA",
      "album"  => "Gold"
    }
    return [album]
  end


  def get_first_album
    return "ACDC"
  end
end
