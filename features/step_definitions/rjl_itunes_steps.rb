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

When(/^I get the album with id (\d+)$/) do |album_id|
  $album = itunes.album( album_id )
  expect($album["Track ID"]).to eql(album_id.to_i)
end

Then(/^it has the artist "([^"]*)"$/) do |artist|
  expect($album["Artist"]).to eql(artist)
end

Then(/^the album title is "([^"]*)"$/) do |title|
  expect($album["Album"]).to eql(title)
end
