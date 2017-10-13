require 'test_helper'
require 'metsiiif/builder'

class BuilderTest < Minitest::Test
  def setup
    iiif_host = 'http://scenery.bc.edu/'
    manifest_host = 'http://library.bc.edu/iiif/manifests'
    @builder = Metsiiif::Builder.new(iiif_host, manifest_host)
  end
end