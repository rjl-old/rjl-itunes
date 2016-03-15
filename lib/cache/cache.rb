#!/usr/bin/env ruby
#
# = cache
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#
require 'YAML'

class Cache
  attr_reader   :cache_name
  attr_accessor :cached_albums

  def initialize( cache_name = "album_cache.yaml" )
    @cache_name = cache_name
    @cached_albums = Hash.new

    if File.exists?(@cache_name)
      # load album dictionary
      @cached_albums = YAML.load_file(@cache_name) || {}
    else
      File.new(@cache_name, "w")
    end
  end

  def make_key( album_obj)
    return "#{album_obj.artist}__#{album_obj.title}"
  end

  def exists?( album_obj )
    return @cached_albums.has_key? make_key( album_obj )
  end

  def update( album_obj, genres, styles )
    key = make_key( album_obj )
    @cached_albums[key] = {genres: genres, styles: styles}
    self.save
  end

  def genres( album_obj )
    key = make_key( album_obj )
    return @cached_albums[key][:genres]
  end

  def styles( album_obj )
    key = make_key( album_obj )
    return @cached_albums[key][:styles]
  end

  def save
    File.open(@cache_name, "w") do |f|
      f.write(@cached_albums.to_yaml)
    end
  end
end
