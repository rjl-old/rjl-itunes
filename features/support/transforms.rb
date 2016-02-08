CAPTURE_TRUE_FALSE = Transform /(True|true|False|false)/ do |state|
  state == "true" || state == "True"
end
