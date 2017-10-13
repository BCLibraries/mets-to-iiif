require 'test_helper'
require 'nokogiri'
require 'metsiiif/mods_record'

class ModsRecordTest < Minitest::Test
  def setup
    mods_path = File.dirname(__FILE__) + '/mods_example.xml'
    doc = File.open(mods_path) {|f| Nokogiri::XML(f)}
    @mods = Metsiiif::ModsRecord.new(doc)
  end

  def test_title_is_found
    assert @mods.title === 'January 1, 1870 - December 1, 1871'
  end

  def test_host_title_is_found
    assert @mods.host_title === 'Reeves family diaries'
  end
end