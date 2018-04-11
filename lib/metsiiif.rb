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
    manifest_host = build_server_string(cnf['manifest_server'])
    metshdr = cnf['mets_fields']['metshdr']
    agent = cnf['mets_fields']['agent']
    dmdsec = cnf['mets_fields']['dmdsec']
    descmd = cnf['mets_fields']['mods']
    amdsec = cnf['mets_fields']['amdsec']
    filesec = cnf['mets_fields']['filesec']
    structmap = cnf['mets_fields']['structmap']

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, manifest_host)
    manifest = @builder.build(mets_path)
    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
