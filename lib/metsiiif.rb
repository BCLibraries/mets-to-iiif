require 'metsiiif/version'
require 'metsiiif/builder'
require 'yaml'
require 'optparse'


module Metsiiif
  def self.main
    OptionParser.new do |parser|
      parser.banner = "Usage: metsiiif [options] /path/to/mets"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    cnf = YAML::load_file(File.join(__dir__, '../config.yml'))

    iiif_host = build_server_string(cnf['iiif_server'])
    iiif_host_http = build_server_string(cnf['iiif_server_http'])
    manifest_host = build_server_string(cnf['manifest_server'])
    image_filetype = "jp2"

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, iiif_host_http, manifest_host)
    manifest = @builder.build(mets_path)
    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
