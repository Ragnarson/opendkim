def decode(content)
  require 'base64'
  Base64.decode64(content)
end
