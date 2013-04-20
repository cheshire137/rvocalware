require 'trollop'
require_relative 'lib/rvocalware.rb'

opts = Trollop::options do
  opt :lid, "Language ID", default: 1
  opt :vid, "Voice ID", default: 3
  opt :txt, "Text to be used for audio creation (encoded)", type: :string
  opt :ext, "SWF or MP3; default MP3", default: 'mp3'
  opt :fx_type, "Sound effect type; default empty", type: :integer
  opt :fx_level, "Sound effect level; default empty", type: :integer
  opt :acc, "Account ID", type: :string
  opt :api, "API ID", type: :string
  opt :session, "Used to verify the session", type: :string
  opt :secret, "Secret phrase", type: :string
  opt :output, "Output audio file name, without extension",
      default: 'rvocalware-txt-to-speech'
end

VALID_EXTS = ['mp3', 'swf']
Trollop::die :acc, "is required" unless opts[:acc]
Trollop::die :api, "is required" unless opts[:acc]
Trollop::die :secret, "is required" unless opts[:acc]
Trollop::die :txt, "is required" unless opts[:acc]
Trollop::die :fx_level, "is required" if opts[:fx_level] && opts[:fx_level] < 1
Trollop::die :fx_type, "is required" if opts[:fx_type] && opts[:fx_type] < 1
if opts[:ext] && !VALID_EXTS.include?(opts[:ext].downcase)
  Trollop::die :ext, "must be either mp3 or swf"
end

processor = RVocalware.new(opts)
processor.download_audio(opts[:output])
puts 'Saved audio to ' + processor.saved_file_name
