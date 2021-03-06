module Metsiiif
  class ModsRecord
    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record, title, subtitle, host_title, creator, owner, accesscondition)
      @mods_record = mods_record
      @title = title
      @subtitle = subtitle
      @host_title = host_title
      @creator = creator
      @owner = owner
      @accesscondition = accesscondition
    end

    def title
      @mods_record.xpath("#{@title}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
    end

    def subtitle
      unless @subtitle.nil?
        @mods_record.xpath("#{@subtitle}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
      end
    end

    def host_title
      @mods_record.xpath("#{@host_title}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
    end

    def creator
      unless @creator.nil?
        @mods_record.xpath("#{@creator}/mods:displayForm/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
      end
    end

    def owner
      if @owner.include?('mods')
        @mods_record.xpath("#{@owner}/mods:namePart[2]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip + ", " + @mods_record.xpath("#{@owner}/mods:namePart[1]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
      else
        @owner
      end
    end

    def rights_information
      if @accesscondition.include?('mods')
        @mods_record.xpath("#{@accesscondition}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
      else
        @accesscondition
      end
    end

    def localcollection
      if @mods_record.xpath("mods:extension/mods:localCollectionName", 'mods' => 'http://www.loc.gov/mods/v3').empty?
        @mods_record.xpath("mods:extension/localCollectionName", 'mods' => 'http://www.loc.gov/mods/v3').map { |node| node.text }
      else
        @mods_record.xpath("mods:extension/mods:localCollectionName", 'mods' => 'http://www.loc.gov/mods/v3').map { |node| node.text }
      end
    end

    def identifier
      @mods_record.xpath("mods:identifier[@type='local']/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s.strip
    end
  end
end