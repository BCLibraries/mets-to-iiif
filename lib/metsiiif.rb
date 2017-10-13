require 'metsiiif/version'
require 'metsiiif/builder'

module Metsiiif
  def self.main
    iiif_host = 'http://scenery.bc.edu'
    manifest_host = 'http://library.bc.edu/iiif/manifests'

    mets_path = ARGV[0]

    @builder = Metsiiif::Builder.new(iiif_host, manifest_host)
    manifest = @builder.build(mets_path)
    puts manifest
  end
end
