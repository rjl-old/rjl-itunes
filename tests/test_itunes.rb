require 'test/unit'
require 'itunes'

ITUNES_PATH_TEST = '/Users/richardlyon/Music/Ruby-iTunes/iTunes Library.xml'
$itunes = Itunes.new ITUNES_PATH_TEST

class TestItunes < Test::Unit::TestCase

  def test_get_albums
    assert_equal(3, $itunes.albums.count)
  end

  def test_album_artist
    album = $itunes.albums[0]
    assert_equal("A Perfect Circle", album.artist)
  end

  def test_album_title
    album = $itunes.albums[0]
    assert_equal("Thirteenth Step", album.title)
  end

  def test_album_genre
    album = $itunes.albums[0]
    assert_equal("Pop/Rock", album.genre)
  end

  def test_set_album_genre
    album = $itunes.albums[0]
    original_genre = album.genre
    test_genre = "TEST GENRE" + Time.now.strftime("%d/%m/%Y %H:%M")
    album.genre = test_genre
    assert_equal( test_genre, album.genre )
    album.genre = original_genre
  end

  def test_get_tracks
    tracks = $itunes.albums[0].tracks
    assert_equal(12, tracks.count)
  end

  def test_get_track_name
    track = $itunes.albums[0].tracks[0]
    assert_equal("The Package", track.name)
  end

  def test_get_track_genre
    track = $itunes.albums[0].tracks[0]
    assert_equal("Pop/Rock", track.genre)
  end

  def test_set_track_genre
    track = $itunes.albums[0].tracks[0]
    original_genre = track.genre
    test_genre = "TEST GENRE" + Time.now.strftime("%d/%m/%Y %H:%M")
    track.genre = test_genre
    assert_equal( test_genre, track.genre )
    track.genre = original_genre
  end

  def test_set_track_comment
    track = $itunes.albums[0].tracks[0]
    original_comment = track.comment
    test_comment = "TEST COMMENT" + Time.now.strftime("%d/%m/%Y %H:%M")
    track.comment = test_comment
    assert_equal( test_comment, track.comment )
    track.comment = original_comment
  end

end
