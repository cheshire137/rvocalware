require 'trollop'
require 'open-uri'
require 'net/http'
require 'digest/md5'

opts = Trollop::options do
  opt :lid, "Language ID", default: 1
  opt :vid, "Voice ID", default: 3
  opt :txt, "Text to be used for audio creation (encoded)", type: :string
  opt :ext, "SWF or MP3; default MP3", default: 'mp3'
  opt :fx_type, "Sound effect type; default empty", type: :string
  opt :fx_level, "Sound effect level; default empty", type: :string
  opt :acc, "Account ID", type: :string
  opt :api, "API ID", type: :string
  opt :session, "Used to verify the session", type: :string
  opt :secret, "Secret phrase", type: :string
end

ENGINE_ID = 3
VOCALWARE_PARAMS = [:lid, :vid, :txt, :ext, :fx_type, :fx_level, :acc, :api,
                    :session, :secret, :eid]

def params_to_query params
  params.map {|p, v| "#{p.upcase}=#{URI.escape(v.to_s)}"}.join('&')
end

def append_uri uri, params={}
  uri = URI.parse(uri)
  return uri if params.empty?
  if uri.query
    uri.query = [uri.query, params_to_query(params)].join('&')
  else
    uri.query = params_to_query(params)
  end
  uri
end

def generate_uri params
  append_uri("http://cache.oddcast.com/tts/gen.php", params)
end

def generate_checksum params
  info = params.values.map(&:to_s).join
  puts info
  Digest::MD5.hexdigest(info)
end

base_options = {eid: ENGINE_ID}.merge(
  opts.select {|k, v| VOCALWARE_PARAMS.include?(k) }
)
cs_options = base_options.merge(cs: generate_checksum(base_options))
puts cs_options
uri = generate_uri(cs_options)

# Net::HTTP.start("cache.oddcast.com") do |http|
#   resp = http.get(uri.path)
#   open("sample.mp3", "wb") do |file|
#     file.write(resp.body)
#   end
# end

File.open("sample.mp3", "wb") do |saved_file|
  open(uri, 'rb') do |read_file|
    saved_file.write(read_file.read)
  end
end
