require 'spec_helper'

describe RJL::Metadata do

  before :all do
    @itunes = RJL::Itunes.new
    @metadata = RJL::Metadata.new( @itunes )
  end

  describe ".genres" do
    context "when given an album" do
      it "gets the album's genres from allmusic" do
        album = @itunes.albums(album_artist: "Simply Red", title: "Greatest Hits" )
        genres = @metadata.genres( album )
        expected_genres = ["Pop/Rock", "R&B"]
        expect(genres).to eq(expected_genres)
      end
    end
  end

  describe ".genre" do
    context "when there is a valid album" do
      it "gets a computed genre" do
        album = @itunes.albums(album_artist: "Simply Red", title: "Greatest Hits" )
        genre = @metadata.genre( album )
        expect(genre).to eq("Pop/Rock [Alternative/Indie Rock]")
      end
    end
    context "when there is not a valid album" do
      it "returns an empty string" do
        album = @itunes.albums(album_artist: "sdafadsf", title: "sadfsadf" )
        genre = @metadata.genre( album )
        expect(genre).to eq("")
      end
    end
  end
end
