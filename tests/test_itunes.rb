require 'test/unit'
require 'itunes'

ITUNES_PATH_TEST = '/Users/richardlyon/Music/Ruby-iTunes/iTunes Library.xml'
$itunes = Itunes.new
$itunes_test = Itunes.new( "TEST" )
$itunes_test_protected = Itunes.new( "TEST-PROTECTED" )
$itunes_test_unprotected = Itunes.new( "TEST-UNPROTECTED" )
$itunes_test_compilation = Itunes.new( "TEST-COMPILATION" )

class TestItunes < Test::Unit::TestCase

  def test_get_albums
    assert_equal(9, $itunes.albums.count)
  end

  def test_get_album_artist
    album = $itunes_test.albums[0]
    assert_equal("Benny Green", album.artist)
  end

  def test_get_album_title
    album = $itunes_test.albums[0]
    assert_equal("These Are Soulful Days", album.title)
  end

  def test_get_album_genre
    album = $itunes_test.albums[0]
    assert_equal("Jazz [Guitar Jazz]", album.genre)
  end

  def test_get_tracks
    tracks = $itunes_test.albums[0].tracks
    assert_equal(8, tracks.count)
  end

  def test_get_track_name
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("Virgo", track.name)
  end

  def test_get_track_artist
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("Benny Green", track.artist)
  end

  def test_get_track_album
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("These Are Soulful Days", track.album)
  end

  def test_get_track_album_artist
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("Benny Green", track.album_artist)
  end

  def test_get_track_composer
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("Benny Green", track.composer)
  end

  def test_get_track_grouping
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("[personal][protected]", track.grouping)
  end

  def test_get_track_genre
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("Jazz [Guitar Jazz]", track.genre)
  end

  def test_get_track_comment
    track = $itunes_test.albums[0].tracks[0]
    assert_equal("TEST COMMENT", track.comment)
  end

  def test_album_protected
    album = $itunes_test.albums[0] # => "Benny Green / These are Soulful Days"
    assert_equal( album.protected?, true)
  end

  def test_album_not_protected
    album = $itunes_test_unprotected.albums[0] # => "A Perfect Circle / Thirteenth Step"
    assert_equal( album.protected?, false)
  end

  def test_track_compilation
    track = $itunes_test_compilation.albums[0].tracks[0]
    assert_equal( true, track.compilation?)
  end

  def test_set_album_genre
    album = $itunes.albums[0]
    set_parameter( album, 'genre' )
  end

  def test_set_track_name
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'name')
  end

  def test_set_track_artist
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'artist')
  end

  def test_set_track_sort_artist
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'sort_artist')
  end

  def test_set_track_album
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'album')
  end

  def test_set_track_sort_album
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'sort_album')
  end

  def test_set_track_album_artist
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'album_artist')
  end

  def test_set_track_composer
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'composer')
  end

  def test_set_track_grouping
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'grouping')
  end

  def test_set_track_genre
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'genre')
  end

  def test_set_track_comment
    track = $itunes.albums[0].tracks[0]
    set_parameter( track, 'comment')
  end

  def set_parameter( itunes_obj, parameter )
    # change to dummy value then revert to original
    original_parameter = itunes_obj.send(parameter)
    test_parameter = "TEST #{parameter} " + Time.now.strftime("%d/%m/%Y %H:%M")
    itunes_obj.send("#{parameter}=", test_parameter)
    assert_equal( test_parameter, itunes_obj.send(parameter) )
    itunes_obj.send( "#{parameter}=", original_parameter)
  end
end
