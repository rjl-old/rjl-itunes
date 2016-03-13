class Album 

  attr_reader   :artist
  attr_reader   :album
  attr_reader   :long_name  # "artist / album"
  attr_accessor :grouping
  attr_accessor :genre
  attr_reader   :track_type
  attr_reader   :album_hash
  attr_reader   :location

  def initialize album_hash
    @album_hash = album_hash
    parse_album_hash
  end

  # We set the properties of the album to be the properties of the first
  # track in the album. This is fragile and will fail for mixed albums e.g.
  # local and remote tracks.
  # TODO make this more robust e.g. check for inconsistencies and flag
  def parse_album_hash
    track_id, track_hash = album_hash.first
    @artist = track_hash["Artist"]
    @album = track_hash["Album"]
    @long_name = "#{@artist} / #{@album}"
    @genre = track_hash["Genre"]
    @location = track_hash["Location"]
  end

  def genre=( new_genre )
    # write new genre to filesystem
    @album_hash.each do |track_id, track_hash|
      if track_hash["Track Type"] == "File"
        begin
          file_path = URI.decode(track_hash["Location"]).gsub('file://','')
          track = Track.new file_path
          track.genre = new_genre
          $log.info "Set #{@long_name} genre to #{new_genre}"
        rescue
          raise "Couldn't get filepath for #{track_hash}"
        end
      else
        # process Remote file
        $log.info "****** #{@long_name}"
      end
    end
  end

  def comment=( new_comment )
    # write new genre to filesystem
    @album_hash.each do |track_id, track_hash|
      if track_hash["Track Type"] == "File"
        file_path = URI.decode(track_hash["Location"]).gsub('file://','')
        track = Track.new file_path
        track.comment = new_comment
        $log.info "Set #{@long_name} comment to #{new_comment}"
      else
        # process Remote file
      end
    end
  end

end
