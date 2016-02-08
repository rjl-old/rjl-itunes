require 'pp'

tracks = {
  "1" =>
  {
    "Artist" => "Abba",
    "Album" => "Gold"
  },
  "2" =>
  {
    "Artist" => "Abba",
    "Album" => "Greatest Hits"
  },
  "3" =>
  {
    "Artist" => "ACDC",
    "Album" => "Back in Black"
  },
  "4" =>
  {
    "Artist" => "ACDC",
    "Album" => "Greatest Hits"
  }
}

artist = "Abba"
album = "Gold"

album_tracks = tracks.reject { |key, hash|
  hash["Artist"] != artist || hash["Album"] != album
}

pp tracks

puts "*"*50

pp album_tracks
