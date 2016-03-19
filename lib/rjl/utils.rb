require 'logger'

# return true if tracks have only one value for 'parameter_name'
def unique?( tracks, parameter_name )
  values = []
  tracks.each do |track|
    values << track.send( parameter_name )
  end
  return values.uniq.length == 1
end


# a logger
def get_logger
  log_path = File.join((File.dirname __dir__), 'logs/log.log')
  logger = Logger.new(log_path, 'daily')
  logger.datetime_format = "%Y-%m-%d"
  return logger
end
