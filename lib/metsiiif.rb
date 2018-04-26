require 'metsiiif/version'
require 'metsiiif/builder'
require 'yaml'
require 'optparse'

module Metsiiif
  class Config
    attr_reader :cnf
    @cnf = YAML::load_file(File.join(__dir__, '../config.yml'))
    def self.cnf
      @cnf
    end
  end

  def self.main
    OptionParser.new do |parser|
      parser.banner = "Usage: metsiiif [options] /path/to/mets"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    iiif_host = build_server_string(Config.cnf['iiif_server'])
    iiif_host_http = build_server_string(Config.cnf['iiif_server_http'])
    manifest_host = build_server_string(Config.cnf['manifest_server'])

    image_filetype = Config.cnf['image_filetype']

    agent = Config.cnf['mets_fields']['agent']
    descmd = Config.cnf['mets_fields']['descmd']
    structmap = Config.cnf['mets_fields']['structmap']

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, iiif_host_http, manifest_host, image_filetype)
    manifest = @builder.build(mets_path, agent, descmd, structmap)

    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
