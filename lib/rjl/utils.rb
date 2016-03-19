# return true if tracks have only one value for 'parameter_name'
def unique?( tracks, parameter_name )
  values = []
  tracks.each do |track|
    values << track.send( parameter_name )
  end
  return values.uniq.length == 1
end
