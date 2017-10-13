require 'test_helper'
require 'metsiiif/mets_file'
require 'metsiiif/mods_record'


class MetsFileTest < Minitest::Test
  def setup
    mets_path = File.dirname(__FILE__) + '/MS2012_003_51529_mets.xml'
    @mets = Metsiiif::MetsFile.new(mets_path)
  end

  def test_agent_is_found
    assert @mets.agent_name == 'Archives and Manuscripts Department'
  end

  def test_object_id_is_found
    assert @mets.obj_id === 'MS2012_003_51529'
  end

  def test_structmap_is_found
    struct_map = @mets.struct_map
    assert struct_map.length === 252
    assert struct_map[14] === 'MS2012_003_51529_0014'
  end

  def test_mods_gives_back_mods
    #assert_instance_of('asdas', @mets.mods)
  end

  def test_sequence_label_is_found
    assert @mets.sequence_label === 'MS.2012.003'
  end
end