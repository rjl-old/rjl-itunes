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

When(/^I get the first album$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^it has the artist "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the album title is "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end
