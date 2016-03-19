require 'spec_helper'

describe RJL::Track do
  before :each do
    @track = RJL::Itunes.new( "TEST" ).albums[0].tracks[0]
  end

  describe ".name" do
    it "returns the correct name" do
      expect(@track.name).to eql("Virgo")
    end
  end

end
