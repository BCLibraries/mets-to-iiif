require 'metsiiif/version'
require 'metsiiif/opts'
require 'metsiiif/builder'
require 'optparse'

module Metsiiif
  def self.main
    opt_parser = Opts.parse(ARGV)
    cnf = Opts.cnf

    iiif_host = build_server_string(cnf['iiif_server'])
    manifest_host = build_server_string(cnf['manifest_server'])

    image_filetype = cnf['image_filetype']

    descmd = cnf['mets_fields']['descmd']
    structmap = cnf['mets_fields']['structmap']
    sequence_div = cnf['mets_fields']['sequence_div']
    component_div = cnf['mets_fields']['component_div']
    logical_div = cnf['mets_fields']['logical_div']

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, manifest_host, image_filetype)
    manifest = @builder.build(mets_path, descmd, structmap, sequence_div, component_div, logical_div)

    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end
