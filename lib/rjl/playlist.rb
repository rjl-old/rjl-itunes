#!/usr/bin/env ruby
#
# = Playlist
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#
module RJL
  class Playlist
    attr_reader :tracks
    def initialize( playlist_obj )
      @playlist_obj = playlist_obj
      @folder = playlist_obj.special_kind.get
      @tracks = get_tracks( playlist_obj )
    end

    def get_tracks( playlist_obj )
      tracks = []
      track_obj_list = playlist_obj.tracks.get
      track_obj_list.each do |track_obj|
        tracks << RJL::Track.new( track_obj )
      end
      return tracks
    end

    def name
      return @playlist_obj.name.get
    end
    def name=(str)
      @playlist_obj.name.set(str)
    end

    def tracks
      return @tracks
    end
    def tracks=(track_list)
      track_list.each do |track|
        app("iTunes").library_playlists[1].tracks[its.database_ID.eq(track.database_id)].duplicate(:to => app.playlists[self.name])
      end
      @tracks = track_list
    end
  end
end
