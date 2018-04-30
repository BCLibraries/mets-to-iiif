require 'metsiiif/version'
require 'metsiiif/config'
require 'metsiiif/builder'
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

    cnf = Config.cnf

    iiif_host = build_server_string(cnf['iiif_server'])
    manifest_host = build_server_string(cnf['manifest_server'])

    image_filetype = cnf['image_filetype']

    agent = cnf['mets_fields']['agent']
    descmd = cnf['mets_fields']['descmd']
    structmap = cnf['mets_fields']['structmap']

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, manifest_host, image_filetype)
    manifest = @builder.build(mets_path, agent, descmd, structmap)

    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
