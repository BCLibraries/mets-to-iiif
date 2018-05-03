require 'nokogiri'
require 'metsiiif/opts'
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
      cnf = Opts.cnf

      mods_node = @doc.xpath(@descmd, 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
      title = cnf['mods_fields']['title']
      host_title = cnf['mods_fields']['host_title']
      creator = cnf['mods_fields']['creator']
      owner = cnf['mods_fields']['owner']
      accesscondition = cnf['mods_fields']['accesscondition']

      ModsRecord.new(mods_node, title, host_title, creator, owner, accesscondition)
    end

    def sequence_label
      @doc.xpath("#{@structmap}/mets:div[@TYPE='DAO' or @TYPE='item' or @TYPE='images']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end

    def component_label
      @doc.xpath("#{@structmap}/mets:div[@TYPE='DAOcomponent' or @TYPE='page' or @TYPE='image']/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s
    end
  end
end
