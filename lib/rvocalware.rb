require 'open-uri'
require 'net/http'
require 'digest/md5'

class RVocalware
  attr_reader :options, :base_api_uri, :saved_file_name
  ENGINE_ID = 3
  DEFAULT_API_URI = "http://cache.oddcast.com/tts/gen.php"
  URI_PARAM_NAMES = [:lid, :vid, :txt, :ext, :fx_type, :fx_level, :acc, :api,
                     :session, :secret, :eid]

  def initialize all_options, base_api_uri=DEFAULT_API_URI
    @options = self.class.get_vocalware_options(all_options)
    @base_api_uri = base_api_uri
    @saved_file_name = nil
  end

  def download_audio output_file_name
    options = get_base_options
    uri = generate_uri(options.merge(cs: generate_checksum(options)))
    file_name = "#{output_file_name}.#{@options[:ext]}"
    File.open(file_name, "wb") do |saved_file|
      open(uri, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end
    @saved_file_name = file_name
  end

  private

  def self.get_vocalware_options all_options
    all_options.select {|k, v| URI_PARAM_NAMES.include?(k) }
  end

  def get_base_options
    {eid: ENGINE_ID}.merge @options
  end

  def self.params_to_query params
    params.map {|k, v| "#{k.upcase}=#{URI.escape(v.to_s)}"}.join('&')
  end

  def self.append_uri uri, params={}
    uri = URI.parse(uri)
    return uri if params.empty?
    if uri.query
      uri.query = [uri.query, params_to_query(params)].join('&')
    else
      uri.query = params_to_query(params)
    end
    uri
  end

  def generate_uri uri_params
    self.class.append_uri @base_api_uri, uri_params
  end

  # See https://www.vocalware.com/support/download-reference, page 15 for how to
  # generate checksum.
  def generate_checksum params
    Digest::MD5.hexdigest params.values.map(&:to_s).join
  end
end
