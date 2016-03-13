require 'uri'
require 'taglib'

# Represents an audio file in the file system
class Track

  def initialize(track_hash)
    @filepath = parse_location(track_hash["Location"])
    @track_hash = track_hash
  end

  def parse_location( location )
    return URI.decode(location).gsub('file://','')
  end

  def artist
    return @track_hash["Artist"]
  end

  def album
    return @track_hash["Album"]
  end

  def name
    return @track_hash["Name"]
  end

  def genre
    TagLib::FileRef.open(@filepath) do |fileref|
      tag = fileref.tag
      return tag.genre
    end
  end

  def genre=(str)
    TagLib::FileRef.open(@filepath) do |fileref|
      tag = fileref.tag
      tag.genre = str
      fileref.save
    end
  end

  def comment
    TagLib::FileRef.open(@filepath) do |fileref|
      tag = fileref.tag
      return tag.comment
    end
  end

  def comment=(str)
    TagLib::FileRef.open(@filepath) do |fileref|
      tag = fileref.tag
      tag.comment = str
      fileref.save
    end
  end
end
