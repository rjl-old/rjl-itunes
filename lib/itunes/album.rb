require_relative 'track'

class Album

  attr_reader   :artist
  attr_reader   :title
  attr_accessor :genre
  attr_reader   :tracks
  attr_reader   :long_name  # "artist / album"

  def initialize track_hash_list
    @track_hash_list = track_hash_list
    @tracks = get_tracks( track_hash_list )
  end

  # counts the number of different values of 'parameter_name' in 'track_list'
  def unique?( track_list, parameter_name)
    values = Hash.new
    track_list.each do |track|
      values[track.send(parameter_name)] = '*'
    end
    return values.keys.count == 1
  end

  # returns value of 'parameter_name' from 'track_list' if unique, or 'mixed'
  def get_parameter( track_list, parameter_name )
    if unique?(track_list, parameter_name)
      return track_list[0].send(parameter_name)
    else
      return "mixed"
    end
  end

  def artist
    return get_parameter( @tracks, "artist")
  end

  def title
    return get_parameter( @tracks, "album")
  end

  def genre
    return get_parameter( @tracks, "genre")
  end

  def get_tracks( track_hash_list )
    track_list = []
    track_hash_list.each do |track_hash|
      track_list << Track.new(track_hash)
    end
    return track_list
  end

  # write new genre to filesystem
  def genre=( new_genre )
    @tracks.each do |track|
      track.genre = new_genre
    end
  end

  # write new comment to filesystem
  def comment=( new_comment )
    @tracks.each do |track|
      track.comment = new_comment
    end
  end

  def long_name
    return "#{self.artist}, '#{self.title}'"
  end
end
