require 'test/unit'
require 'itunes'

ITUNES_PATH_TEST = '/Users/richardlyon/Music/Ruby-iTunes/iTunes Library.xml'
$itunes = Itunes.new

class TestItunes < Test::Unit::TestCase

  def test_get_albums
    assert_equal(3, $itunes.albums.count)
  end

  def test_get_album_artist
    album = $itunes.albums[0]
    assert_equal("Benny Green", album.artist)
  end

  def test_get_album_title
    album = $itunes.albums[0]
    assert_equal("These Are Soulful Days", album.title)
  end

  def test_get_album_genre
    album = $itunes.albums[0]
    assert_equal("Jazz [Guitar Jazz]", album.genre)
  end

  def test_get_tracks
    tracks = $itunes.albums[0].tracks
    assert_equal(8, tracks.count)
  end

  def test_get_track_name
    track = $itunes.albums[0].tracks[0]
    assert_equal("Virgo", track.name)
  end

  def test_get_track_genre
    track = $itunes.albums[0].tracks[0]
    assert_equal("Jazz [Guitar Jazz]", track.genre)
  end

  def test_album_protected
    album = $itunes.albums[0] # => "Benny Green / These are Soulful Days"
    assert_equal( album.protected?, true)
  end

  def test_album_not_protected
    album = $itunes.albums[1] # => "A Perfect Circle / Thirteenth Step"
    assert_equal( album.protected?, false)
  end

  def test_set_track_genre
    track = $itunes.albums[0].tracks[0]
    original_genre = track.genre
    test_genre = "TEST GENRE" + Time.now.strftime("%d/%m/%Y %H:%M")
    track.genre = test_genre
    assert_equal( test_genre, track.genre )
    track.genre = original_genre
  end

  def test_set_album_genre
    album = $itunes.albums[0]
    original_genre = album.genre
    test_genre = "TEST GENRE" + Time.now.strftime("%d/%m/%Y %H:%M")
    album.genre = test_genre
    assert_equal( test_genre, album.genre )
    album.genre = original_genre
  end
end
