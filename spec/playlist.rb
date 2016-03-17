require_relative "../lib/itunes"

describe Playlist do
  before :each do
    @itunes = Itunes.new
    @test_playlist_name = "TEST " + Time.now.strftime("%d/%m/%Y %H:%M")
  end

  describe ".create_playlist" do

    context "when no tracks are given" do
      it "creates an empty playlist" do
        @itunes.create_playlist( playlist_name: @test_playlist_name )
        playlist = @itunes.playlist( @test_playlist_name )
        expect(playlist.name).to eq( @test_playlist_name )
        @itunes.destroy_playlist( @test_playlist_name )
      end
    end

    context "when tracks are given" do
      it "creates a playlist with the tracks" do
        some_tracks = @itunes.albums[2].tracks
        @itunes.create_playlist( playlist_name: @test_playlist_name, track_list: some_tracks )
        playlist = @itunes.playlist( @test_playlist_name )
        expect(playlist.tracks.count).to eq(some_tracks.count)
        @itunes.destroy_playlist( @test_playlist_name )
      end
    end
  end

  describe ".create_playlist_folder" do

    context "when no playlists are given" do
      it "creates an empty playlist folder" do
        @itunes.create_playlist_folder( folder_name: @test_playlist_name )
        # TODO check it exists
        @itunes.destroy_playlist_folder( folder_name: @test_playlist_name )
      end
    end

    context "when playlists are given" do
      it "creates a playlist folder with the playlists" do
        playlist = @itunes.create_playlist( playlist_name: @test_playlist_name )
        @itunes.create_playlist_folder( folder_name: @test_playlist_name, playlists: [playlist] )
        # TODO check it exists
        @itunes.destroy_playlist_folder( folder_name: @test_playlist_name )
      end
    end
  end
end
