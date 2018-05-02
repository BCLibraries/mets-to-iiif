module Metsiiif
  class ModsRecord
    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record, title, host_title, creator, owner, accesscondition)
      @mods_record = mods_record
      @title = title
      @host_title = host_title
      @creator = creator
      @owner = owner
      @accesscondition = accesscondition
    end

    def title
      @mods_record.xpath("#{@title}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def host_title
      @mods_record.xpath("#{@host_title}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def creator
      unless @creator.nil?
        @mods_record.xpath("#{@creator}/mods:displayForm/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end

    def owner
      unless @owner.nil?
        @mods_record.xpath("#{@owner}/mods:namePart[2]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s + ", " + @mods_record.xpath("#{@owner}/mods:namePart[1]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end

    def rights_information
      if @accesscondition.include?('mods')
        @mods_record.xpath("#{@accesscondition}/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      else
        @accesscondition
      end
    end
  end
end