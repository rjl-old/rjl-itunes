require_relative "../lib/itunes"

describe Album do

  before :all do
    @itunes = Itunes.new
    TEST = "TEST " + Time.now.strftime("%d/%m/%Y %H:%M")
  end

  describe ".albums" do

    context "when no album or artist are specified " do
      it "returns all the albums" do
        expect(@itunes.albums.count).to eq(24)
      end
    end

    context "when an album artist is specified" do
      it "returns all albums by that artist" do
        album_artist = "Altan"
        albums = @itunes.albums(album_artist: album_artist)
        expect(albums.count).to eq(2)
        albums.each do |album|
          expect(album.album_artist).to eq(album_artist)
        end
      end
    end

    context "when an album title is specified" do
      it "returns all albums with that title" do
        album_title = "Greatest Hits"
        albums = @itunes.albums(title: album_title)
        expect(albums.count).to eq(2)
        albums.each do |album|
          expect(album.title).to eq(album_title)
        end
      end
    end

    context "when an album title and artist is specified" do
      it "returns that album " do
        album_artist = "Simply Red"
        album_title = "Greatest Hits"
        album = @itunes.albums(album_artist: album_artist, title: album_title )
        expect(album.class).to eq Album
        expect(album.title).to eq(album_title)
        expect(album.album_artist).to eq(album_artist)
      end
    end

    context "when a non-existent title and artist is specified" do
      it "returns nil" do
        album_artist = "sdfsadasd"
        album_title = "asasasdfasdf"
        album = @itunes.albums(album_artist: album_artist, title: album_title )
        expect(album).to be_nil
      end
    end

    context "when track artists in an album are all the same" do
      it "returns as album artist the track artists" do
        album_artist = "Simply Red"
        album_title = "Greatest Hits"
        album = @itunes.albums(album_artist: album_artist, title: album_title )
        expect(album.album_artist).to eq(album_artist)
      end
    end

    context "when track artists in an album are all not the same" do
      it "returns as album artist 'Various Artists'" do
        album_title = "The Firm"
        album = @itunes.albums(title: album_title )[0]
        expect(album.album_artist).to eq('Various Artists')
      end
    end

    context "when I change the genre of an album" do
      it "changes all the genres of the album's tracks" do
        album = @itunes.albums(album_artist: "Simply Red", title: "Greatest Hits" )
        old_genre = album.genre
        expect(old_genre).to eq("Pop/Rock [Adult Contemporary]")
        album.genre = TEST
        expect(album.tracks[0].genre).to eq(TEST)
        album.genre = old_genre
      end
    end

    context "when an album is protected" do
      it "the genre can't be changed" do
        album = @itunes.albums(album_artist: "Benny Green", title: "These Are Soulful Days" )
        old_genre = album.genre
        expect(old_genre).to eq("Jazz [Guitar Jazz]")
        album.genre = TEST
        expect(album.tracks[0].genre).to eq(old_genre)
        album.genre = old_genre
      end
    end
  end
end
