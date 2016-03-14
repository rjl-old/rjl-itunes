#!/usr/bin/env ruby
#
# = Track
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

class Track
  def initialize track_obj
    @track_obj = track_obj
  end

  def album
    return @track_obj.album.get
  end

  def artist
    return @track_obj.artist.get
  end

  def name
    return @track_obj.name.get
  end

  def genre
    return @track_obj.genre.get
  end

  def genre=(str)
    @track_obj.genre.set(str)
  end

  def tags
    groupings = @track_obj.grouping.get
    return groupings.gsub("][", ",")[1..-2].split(',')
  end
end
