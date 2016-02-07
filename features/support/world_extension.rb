module KnowsTheDomain
  def itunes
    @itunes ||= Itunes.new
  end
end

World(KnowsTheDomain)
