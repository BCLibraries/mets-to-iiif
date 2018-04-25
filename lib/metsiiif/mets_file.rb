require 'nokogiri'
require 'metsiiif/mods_record'

module Metsiiif
  class MetsFile
    def initialize(mets_path, agent, descmd, structmap)
      @doc = File.open(mets_path) {|f| Nokogiri::XML(f)}
      @agent = agent
      @descmd = descmd
      @structmap = structmap
    end

    def obj_id
      uri = @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s
      uri.split('/').last
    end

    def handle
      @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def agent_name
      @doc.xpath("#{@agent}/mets:name/text()", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def struct_map
      structmap = @doc.xpath("#{@structmap}/mets:div[@TYPE='DAO' or @TYPE='item']/mets:div[@TYPE='DAOcomponent' or @TYPE='page']", 'mets' => 'http://www.loc.gov/METS/')
      structmap.map {|component| component['LABEL']}
    end

    # @return [Metsiiif::ModsRecord]
    def mods
      mods_node = @doc.xpath(@descmd, 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
      ModsRecord.new(mods_node, @title, @relateditem, @roleterm, 
                     @useandreproduction, @restrictiononaccess, 
                     @conditions_governing_use_note)
    end

    def sequence_label
      @doc.xpath("#{@structmap}/mets:div[@TYPE='DAO' or @TYPE='item']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def component_label
      @doc.xpath("#{@structmap}mets:div[@TYPE='DAOcomponent' or @TYPE='page']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

  end
end
