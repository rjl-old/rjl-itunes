#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require "rb-scpt" # https://github.com/BrendanThompson/rb-scpt
include Appscript
require_relative 'album'
require_relative 'playlist'

class Itunes

  attr_reader :albums
  attr_reader :tracks
  attr_reader :tags

  def initialize( playlist = nil )
    @tracks = get_tracks( playlist )
    @albums = get_albums(@tracks)
    @playlists = fetch_playlists( kind: :none )
    @playlist_folders = fetch_playlists( kind: :none )
  end

  # Return a list of the playlists.
  # @param [String] artist The album artist
  # @param [String] title The album title
  # @return [List of Album] the albums
  def albums( artist: nil, title: nil )
    albums = []
    if artist.nil? && title.nil?
      albums = @albums
    elsif !artist.nil? && title.nil?
      albums = @albums.select{ |album| album.artist == artist }
    elsif artist.nil? && !title.nil?
      albums = @albums.select{ |album| album.title == title }
    elsif !artist.nil? and !title.nil?
      albums = @albums.select{ |album| album.artist == artist && album.title == title}
      albums = albums[0]
    end
    return albums
  end

  # Return a list of the playlists.
  #
  # @return [List of Playlist] the playlists
  def playlists
    return @playlists
  end

  # Get a playlist of the specified name. Raises error if more than one.
  #
  # @param playlist_name [String] The name of the playlist to get
  # @return [Playlist] the named playlist
  def playlist( playlist_name )
    play_list = @playlists.select { |playlist| playlist.name == playlist_name }
    if play_list.count == 1
      return play_list[0]
    else
      raise "ERROR: #{play_list.count} playlists with name #{playlist_name}"
    end
  end

  def create_playlist( playlist_name: "Playlist", track_list: nil )
    playlist_obj = app("iTunes").make(
      :new => :playlist,
      :with_properties => {:name => playlist_name}
      )
    playlist = Playlist.new( playlist_obj )
    playlist.tracks = track_list unless track_list.nil?
    @playlists << playlist
    return playlist
  end

  def destroy_playlist( playlist_name )
    app("iTunes").sources["Library"].user_playlists[playlist_name].delete
    # TODO remove from @playlists
  end

  def create_playlist_folder( folder_name: "untitled folder", playlists: nil )
    playlist_obj = app("iTunes").make(
      :new => :folder_playlist,
      :with_properties => {:name => folder_name}
      )
    # TODO add playlists
    # TODO make and add to @playlist_folders
  end

  def destroy_playlist_folder( folder_name: nil )
    app("iTunes").sources["Library"].folder_playlists[folder_name].delete
  end

  private

  def fetch_playlists( kind: :none )
    playlist_list = []
    reject_list = ["Music Videos", "Home Videos", "Books", "PDFs", "Audiobooks"]
    playlists = app("iTunes").user_playlists[its.special_kind.eq(:none)].get
    playlists.each do |playlist_obj|
      playlist_list << Playlist.new( playlist_obj ) unless reject_list.include? (playlist_obj.name.get)
    end
    return playlist_list
  end

  def get_tracks( playlist = nil)
    track_list = []
    if playlist.nil?
      tracks = app("iTunes").playlists[1].tracks[its.video_kind.eq(:none)].get
    else
      tracks = app("iTunes").playlists[playlist].tracks[its.video_kind.eq(:none)].get
    end
    tracks.each do |track_obj|
      track_list << Track.new(track_obj)
    end
    return track_list
  end

  def make_key( artist, album )
    return "#{artist}__#{album}"
  end

  def get_albums( track_list )
    album_list = []
    tracks_hash = Hash.new { |hash, key| hash[key] = [] }
    track_list.each do |track|
      key = make_key(track.artist, track.album)
      tracks_hash[key] << track
    end
    tracks_hash.each do |key, tracks|
      artist, title = key.split('__')
      album_list << Album.new(artist: artist, title: title, tracks: tracks)
    end
    return album_list
  end

  def get_playlists
  end
end
