module Metsiiif
  class ModsRecord
    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record, title, relateditem, owner, accesscondition)
      @mods_record = mods_record
      @title = title
      @relateditem = relateditem
      @owner = owner
      @accesscondition = accesscondition
    end

    def title
      @mods_record.xpath("#{@title}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def host_title
      @mods_record.xpath("#{@relateditem}/#{@title}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def owner
      if @owner.include?('mods') && @mods_record.xpath("#{@owner}", 'mods' => 'http://www.loc.gov/mods/v3').to_s == 'Owner'
        @mods_record.xpath("mods:name/mods:namePart[2]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s + ", " + @mods_record.xpath("mods:name/mods:namePart[1]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      else
        @owner
      end
    end

    def rights_information
      if @accesscondition.include?('mods')
        @mods_record.xpath("#{@accesscondition}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      else
        @accesscondition
      end
    end
  end
end