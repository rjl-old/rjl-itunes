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
require_relative 'utils'

# Represents the Apple's 'iTunes' application.
# @example itunes = Itunes.new

class Itunes

  attr_reader :version   # @return [String] the iTunes application version number.
  attr_reader :albums
  attr_reader :tags

  def initialize( playlist = nil )
    @tracks = get_tracks( playlist )
    @albums = get_albums( @tracks )
    @playlists = fetch_playlists( kind: :none )
    @playlist_folders = fetch_playlists( kind: :none )
  end

  def version
    return app("iTunes").version.get
  end

  # The albums, or a single album
  # @example
  #   albums = itunes.albums
  #   puts albums.count # => 5
  #
  #   album = itunes.albums(album_artist: "Simply Red", title: "Greatest Hits" )
  #   puts album.genre # => "Pop/Rock"
  # @param [String] artist the album artist
  # @param [String] title the album title
  # @return [List of Album]  if more than one album
  # @return [Album] if only one album
  def albums( album_artist: nil, title: nil )
    albums = []
    if album_artist.nil? && title.nil?
      albums = @albums
    elsif !album_artist.nil? && title.nil?
      albums = @albums.select{ |album| album.album_artist == album_artist }
    elsif album_artist.nil? && !title.nil?
      albums = @albums.select{ |album| album.title == title }
    elsif !album_artist.nil? and !title.nil?
      albums = @albums.select{ |album| album.album_artist == album_artist && album.title == title}
      albums = albums[0]
    end
    return albums
  end

  # Return a list of the playlists.
  # @return [List of Playlist] the playlists
  def playlists
    return @playlists
  end

  # Get a playlist of the specified name. Raises error if more than one.
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

  # Get the tracks
  # @param [String] playlist the name of a playlist to get tracks from
  # @return [List of Track] the tracks
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

  # Get the albums
  # Three possibilities:
  #   1. one album, one artist e.g. "Spiceworld, Spice Girls"
  #   2. one album, multiple artists, not compilation  e.g. "Greatest Hits"
  #   3. one album, multiple artists, compilation e.g. "The Firm"
  # @param [List of Track] the tracks
  # @return [List of Album] the albums
  def get_albums( tracks )

    album_list = []

    # build hash of tracks with album name as key
    album_hash = Hash.new { |h,k| h[k] = [] }
    tracks.each do |track|
      album_hash[track.album] << track
    end

    # split the album tracks by track artist
    album_hash.each do |album_name, album_tracks|
      artist_hash = Hash.new { |h,k| h[k] = [] }
      album_tracks.each do |album_track|
        artist_hash[album_track.artist] << album_track
      end

      if album_tracks[0].compilation?
        album_list << Album.new( tracks: album_tracks)
      else
        artist_hash.each do |artist, tracks|
          album_list << Album.new( tracks: tracks)
        end
      end

    end

    return album_list
  end

  def fetch_playlists( kind: :none )
    playlist_list = []
    reject_list = ["Music Videos", "Home Videos", "Books", "PDFs", "Audiobooks"]
    playlists = app("iTunes").user_playlists[its.special_kind.eq(:none)].get
    playlists.each do |playlist_obj|
      playlist_list << Playlist.new( playlist_obj ) unless reject_list.include? (playlist_obj.name.get)
    end
    return playlist_list
  end

  def make_key( artist, album )
    return "#{artist}__#{album}"
  end

end
