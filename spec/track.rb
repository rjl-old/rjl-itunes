require_relative "../lib/itunes"

describe Track do
  before :each do
    @track = Itunes.new( "TEST" ).albums[0].tracks[0]
  end

  describe ".name" do
    it "returns the correct name" do
      expect(@track.name).to eql("Virgo")
    end
  end

end
