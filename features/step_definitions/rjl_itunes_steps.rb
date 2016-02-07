module KnowsTheDomain
  def itunes
    @itunes ||= Itunes.new
  end
end
World(KnowsTheDomain)

Given(/^there is an iTunes plist$/) do
  itunes = Itunes.new
  expect(itunes.itunes_path).to eq('/Users/richlyon/Music/iTunes/iTunes Music Library.xml')
end

Given(/^it has at least one album$/) do
  expect(itunes.albums).not_to be_empty
end

When(/^I get the first album$/) do
  $album = itunes.albums[0]
end

Then(/^it has the artist "([^"]*)"$/) do |artist|
  expect($album["artist"]).to eql(artist)
end

Then(/^the album title is "([^"]*)"$/) do |title|
  expect($album["album"]).to eql(title)
end
