itunes = Itunes.new 'path_to_xml'

albums = itunes.albums

album = itunes.albums.first

puts album.artist             # => "ABBA"
puts album.album              # => "Gold: Greatest hits"
album.groupings = "Pop/Rock"  # => groupings changed
album.genre = "Swedish Pop"   # => genre changed
itunes.save                   # => xml saved to disk


require 'singleton'

class Itunes

  include Singleton

  XML_FILE = "/path/to/xml"

  @itunes_variable = nil

  # def initialize ( itunes_initialiser )
  #   @itunes_variable = itunes_initialiser
  #   puts "Initialised Itunes class with: #{itunes_initialiser}"
  # end

  def parse_xml
    puts "Parsed #{XML_FILE}"
  end

  def save
    puts "Itunes saving"
  end

  def itunes_variable
    return @itunes_variable
  end

end

class Album < Itunes

  # include Itunes

  def initialize album_name
    puts "Initialised Album class"
    puts "Itunes variable: #{Itunes::itunes_variable}"
  end
end

Itunes.instance.parse_xml

puts "="*50
album1 = Album.new("Abba")


puts "="*50
album2 = Album.new("ACDC")
p Itunes::XML_FILE
