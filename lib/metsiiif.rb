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

    image_filetype = cnf['image_filetype']

    agent = cnf['mets_fields']['agent']
    descmd = cnf['mets_fields']['mods']
    structmap = cnf['mets_fields']['structmap']

    title = cnf['mods_fields']['title']
    relateditem = cnf['mods_fields']['relateditem']
    roleterm = cnf['mods_fields']['roleterm']
    useandreproduction = cnf['mods_fields']['accesscondition']['useandreproduction']
    restrictiononaccess = cnf['mods_fields']['accesscondition']['restrictiononaccess']
    conditions_governing_use_note = cnf['mods_fields']['accesscondition']['conditions_governing_use_note']

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, iiif_host_http, manifest_host, image_filetype)
    manifest = @builder.build(mets_path)
    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
