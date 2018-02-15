require 'nokogiri'
require 'metsiiif/mods_record'

module Metsiiif
  class MetsFile

    HEADER = '/mets:mets/mets:metsHdr'
    AGENT = "#{HEADER}/mets:agent"

    DMDSEC = '/mets:mets/mets:dmdSec'
    MODS = "#{DMDSEC}/mets:mdWrap/mets:xmlData/mods:mods"

    AMDSEC = '/mets:mets/mets:amdSec'

    FILESEC = 'mets:mets/mets:fileSec'

    STRUCTMAP = '/mets:mets/mets:structMap'

    def initialize(mets_path)
      @doc = File.open(mets_path) {|f| Nokogiri::XML(f)}
    end

    def obj_id
      uri = @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s
      uri.split('/').last
    end

    def handle
      @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def agent_name
      @doc.xpath("#{AGENT}/mets:name/text()", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def struct_map
      structmap = @doc.xpath("#{STRUCTMAP}/mets:div[@TYPE='DAO']/mets:div[@TYPE='DAOcomponent']", 'mets' => 'http://www.loc.gov/METS/')
      structmap.map {|component| component['LABEL']}
    end

    # @return [Metsiiif::ModsRecord]
    def mods
      mods_node = @doc.xpath(MODS, 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
      ModsRecord.new(mods_node)
    end

    def sequence_label
      @doc.xpath("#{STRUCTMAP}/mets:div[@TYPE='DAO']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def component_label
      @doc.xpath("#{STRUCTMAP}/mets:div[@TYPE='DAOcomponent']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

  end
end
