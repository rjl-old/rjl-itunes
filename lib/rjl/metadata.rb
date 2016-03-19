require 'allmusic'        # https://github.com/richardjlyon/allmusic
require 'daybreak'        # http://propublica.github.io/daybreak/

module RJL
  # Gets metadata for an album from allmusic.com, caching the results. See
  # [rjl-music](https://github.com/richardjlyon/allmusic) for details. Computes
  # a simplified genre by selecting the highest frequency genre and style in the
  # library and combining them in a string.
  class Metadata

    attr_reader :genres
    attr_reader :styles
    attr_reader :genre

    # Create a new RJL::Metadata from the supplied Itunes object. This opens or
    # creates a cache for storing metadata from allmusic to speed things up, and
    # closes it on exit.
    # @param [Itunes] itunes the itunes client to generate metadata for
    def initialize( itunes )

      cache_path = File.join((File.dirname __dir__), 'cache/cache.db')
      @db = Daybreak::DB.new cache_path, :default => {}
      @itunes = itunes
      at_exit { @db.close }
    end

    # allmusic.com genres for album.
    # @return [List of String] allmusic.com genres for album
    def genres( album )
      return get_metadata( album )[:genres]
    end

    # allmusic.com styles for album.
    # @return [List of String] allmusic.com styles for album
    def styles( album)
      return get_metadata( album )[:styles]
    end

    # Compute a genre for album. Reduce genres and styles and construct a
    # string from them.
    # @param [Album] album
    # @return [String] computed genre for album
    def genre( album )
      metadata = compute_metadata( album )
      @genre = build_genre_string( metadata )
      return @genre
    end

    private

    # Compute the frequencies of each genre and style in the iTunes database
    def compute_frequencies
      genre_freq = Hash.new(0)
      style_freq = Hash.new(0)

      @db.each do |album_key, metadata|
        unless album_key == ""
          metadata[:genres].each{ |key| genre_freq[key] += 1}
          metadata[:styles].each{ |key| style_freq[key] += 1}
        end
      end

      return {genre_freq: genre_freq, style_freq: style_freq }
    end

    # Get genres and styles for the album from allmusic (or the cache, if it exists)
    # @param [Album] the album
    # @return [Hash] {genres: [List of String], styles: [List of String]}
    def get_metadata( album )
      genres = []
      styles = []
      album_key = make_key( album )
      unless album_key.nil?
        if @db[album_key].any?
          genres = @db[album_key][:genres]
          styles = @db[album_key][:styles]
        else
          allmusic = Allmusic.new album.album_artist, album.title
          genres = allmusic.genres
          styles = allmusic.styles
          metadata = { :genres => genres, :styles => styles }
          @db[album_key] = metadata
        end
      end

      return {genres: genres, styles: styles}
    end

    # Reduce multiple genres and styles to a single genre and style.
    # In this approach, select the genre and style with the highest frequency
    # in the library.
    def compute_metadata ( album )
      genre_sort_hash = Hash.new
      style_sort_hash = Hash.new

      frequencies = compute_frequencies
      self.genres( album ).each do |album_genre|
        genre_sort_hash[album_genre] = frequencies[:genre_freq][album_genre]
      end
      genre_sort_list = genre_sort_hash.sort_by{ | genre, count | count }.reverse
      genre, count = genre_sort_list[0]

      self.styles( album ).each do |album_style|
        style_sort_hash[album_style] = frequencies[:style_freq][album_style]
      end
      style_sort_list = style_sort_hash.sort_by{ | style, count | count }.reverse
      style, count = style_sort_list[0]

      return {genre: genre, style: style}
    end

    # Build the genre string e.g. "Jazz", "Guitar Jazz" => "Jazz [Guitar Jazz]"
    def build_genre_string( metada )
      genre = metada[:genre]
      style = metada[:style]
      computed_genre = case
      when genre.nil? && style.nil?
        ""
      when !genre.nil? && style.nil?
        genre
      when genre.nil? && !style.nil?
        style
      else
        "#{genre} [#{style}]"
      end

      return computed_genre
    end

    # @example
    #    key = make_key( album ) # => "ABBA__Gold"
    # @return [String] an album key
    def make_key( album )
      return "#{album.album_artist}__#{album.title}" unless album.nil?
    end
  end
end
