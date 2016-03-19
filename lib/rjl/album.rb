module RJL
  # Represents an album in Apple's 'iTunes' application.
  class Album

    attr_reader   :album_artist
    attr_reader   :title
    attr_accessor :genre
    attr_reader   :tracks

    # Creates a new RJL::Album. Album properties are derived from the
    # properties of the supplied tracks.
    # @param [List of Track] tracks  the album tracks
    def initialize( tracks: [])
      @tracks = tracks
    end

    #  Album's artist e.g "Simply Red". Returns 'Various Artists' if more than one.
    # @return [String artist name] the album artist if only one
    # @return [String 'Various Artists'] if more than one
    def album_artist
      album_artist = nil
      if unique?(@tracks, "artist" )
        album_artist = @tracks[0].artist
      else
        album_artist = 'Various Artists'
      end
      return album_artist
    end

    # Album title e.g "Greatest Hits"
    # @return [String] album title
    def title
      return @tracks[0].album
    end

    # Album genre e.g "Pop/Rock [Alternative/Indie Rock]"
    # @return [String] album genre
    def genre
      if unique?( @tracks, "genre" )
        return @tracks[0].genre
      else
        return 'mixed'
      end
    end

    # @param [String] album genre
    def genre=(str)
      if !self.protected?
        @tracks.each do |track|
          track.genre = str
        end
      end
    end

    # The tracks in the album
    # @return [List of Track] tracks the album tracks
    def tracks
      return @tracks
    end

    # Is the album protected from changes?
    # @return [Boolean] true if it is
    def protected?
      protected = false
      @tracks.each do |track|
        if track.tags.include? 'protected'
          protected = true
          break
        end
      end
      return protected
    end

    def to_s
      puts "-"*50
      puts "> #{self.album_artist}, '#{self.title}'"
      @tracks.each do |track|
        puts "  #{track.name}"
      end
      puts "="*50
    end
  end
end
