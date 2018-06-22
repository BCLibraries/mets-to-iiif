require 'nokogiri'
require 'metsiiif/opts'
require 'metsiiif/mods_record'

module Metsiiif
  class MetsFile
    def initialize(mets_path, descmd, structmap, sequence_div, component_div)
      @doc = File.open(mets_path) { |f| Nokogiri::XML(f) }
      @descmd = descmd
      @structmap = structmap
      @sequence_div = sequence_div
      @component_div = component_div
    end

    def obj_id
      uri = @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s
      if mods.host_title == 'Bobbie Hanvey Photographic Archives'
        prefix = "MS2001_039_"
        prefix + uri.split('/').last
      elsif mods.localcollection.any? { |coll| coll.include?('bcimage') }
        prefix = "bcimage_"
        prefix + uri.split('/').last
      elsif mods.host_title.length == 0 || mods.host_title.include?("Leary") || mods.host_title.include?("Hayward") || mods.host_title.include?("Roche")
        mods.identifier
      else
        uri.split('/').last
      end
    end

    def handle
      @doc.xpath("/mets:mets/@OBJID", 'mets' => 'http://www.loc.gov/METS/').to_s.strip
    end

    def struct_map
      structmap = @doc.xpath("#{@structmap}/#{@sequence_div}/#{@component_div}", 'mets' => 'http://www.loc.gov/METS/')
      structmap.map { |component| component['LABEL'] }
    end

    def file_sec
      filesec = @doc.xpath("/mets:mets/mets:fileSec/mets:fileGrp[@USE='archive image' or @USE='archive']/mets:file/mets:FLocat", 'mets' => 'http://www.loc.gov/METS/', 'xlink' => 'http://www.w3.org/1999/xlink')
      filesec.map { |flocat| flocat['xlink:href'].split('/').last.chomp('.tif') }
    end

    # @return [Metsiiif::ModsRecord]
    def mods
      cnf = Opts.cnf

      mods_node = @doc.xpath(@descmd, 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
      title = cnf['mods_fields']['title']
      subtitle = cnf['mods_fields']['subtitle']
      host_title = cnf['mods_fields']['host_title']
      creator = cnf['mods_fields']['creator']
      owner = cnf['mods_fields']['owner']
      accesscondition = cnf['mods_fields']['accesscondition']

      ModsRecord.new(mods_node, title, subtitle, host_title, creator, owner, accesscondition)
    end

    def sequence_label
      if mods.localcollection.include?('bcimage')
        'Boston College Photographs'
      else
        @doc.xpath("#{@structmap}/#{@sequence_div}/@LABEL", 'mets' => 'http://www.loc.gov/METS/').to_s.strip
      end
    end

    def component_label
      @doc.xpath("#{@structmap}/#{@sequence_div}/#{@component_div}/@LABEL", 'mets' => 'http://www.loc.gov/METS/')
    end
  end
end
