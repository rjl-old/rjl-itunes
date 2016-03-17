require_relative "../lib/itunes"

describe Album do

  describe ".albums" do

    context "when no album or artist are specified " do
      it "returns all the albums" do
        itunes = Itunes.new
        expect(itunes.albums.count).to be > 0
      end
    end

    context "when an album artist is specified" do
      it "returns all albums by that artist" do
        itunes = Itunes.new
        album_artist = "Altan"
        albums = itunes.albums(artist: album_artist)
        expect(albums.count).to be 2
        albums.each do |album|
          expect(album.artist).to eq(album_artist)
        end
      end
    end

    context "when an album title is specified" do
      it "returns all albums with that title" do
        itunes = Itunes.new
        album_title = "Greatest Hits"
        albums = itunes.albums(title: album_title)
        expect(albums.count).to be 2
        albums.each do |album|
          expect(album.title).to eq(album_title)
        end
      end
    end

    context "when an album title and artist is specified" do
      it "returns the album " do
        itunes = Itunes.new
        album_artist = "Simply Red"
        album_title = "Greatest Hits"
        album = itunes.albums(artist: album_artist, title: album_title )
        expect(album.class).to eq Album
        expect(album.title).to eq(album_title)
        expect(album.artist).to eq(album_artist)
      end
    end

    context "when a non-existent title and artist is specified" do
      it "returns nil" do
        itunes = Itunes.new
        album_artist = "sdfsadasd"
        album_title = "asasasdfasdf"
        album = itunes.albums(artist: album_artist, title: album_title )
        expect(album).to be_nil
      end
    end
  end
end
