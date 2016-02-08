require 'pp'


tracks_hash =
  {"1" =>
    {"id" => 1,
     "album" => "album1",
     "track" => "track1"},
   "2" =>
    {"id" => 2,
     "album" => "album1",
     "track" => "track2"},
   "3" =>
    {"id" => 3,
     "album" => "album2",
     "track" => "track1"},
   "4" =>
    {"id" => 4,
     "album" => "album2",
     "track" => "track2"}
  }

desired_hash = {
  "album1" => {
    "1" => {"id" => 1, "album"=>"album1", "track"=>"track1"},
    "2" => {"id" => 2, "album"=>"album1", "track"=>"track2"}},
  "album2" => {
    "3" => {"id" => 3, "album"=>"album2", "track"=>"track1"},
    "4" => {"id" => 4, "album"=>"album2", "track"=>"track2"}}
  }

album_tracks = {}
titles = []
tracks_hash.each do |album_id, album_hash|
  titles << album_hash["album"] if !titles.include? album_hash["album"]
end

albums_hash = {}
titles.each do |title|
  tracks = {}
  tracks_hash.each do |album_id, album_hash|
    tracks[album_id] = album_hash if title == album_hash["album"]
  end
  albums_hash[title] = tracks
end

puts titles

pp tracks_hash
puts "*"*50
pp desired_hash
puts "*"*50
pp albums_hash
