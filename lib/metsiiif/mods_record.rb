module Metsiiif
  class ModsRecord

    TITLE_TEXT = 'mods:titleInfo[@usage="primary"]/mods:title/text()'
    RELATED_ITEM = 'mods:relatedItem[@type="host"]'
    ACCESSION_NUMBER = 'mods:identifier[@type="accession number"]'
    ROLETERM = 'mods:name/mods:role/mods:roleTerm[@type="text"]/text()'

    # Access condition constants
    AC_USE_AND_REPRODUCTION = 'mods:accessCondition[@type="useAndReproduction"]/text()'
    AC_RESTRICTION_ON_ACCESS = 'mods:accessCondition[@type="restrictionOnAccess"]/text()'
    AC_DISPLAY_LABEL = 'mods:accessCondition[@type="useAndReproduction"][@displayLabel="Conditions Governing Use note"]/text()'

    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record)
      @mods_record = mods_record
    end

    def title
      @mods_record.xpath("#{TITLE_TEXT}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def host_title
      @mods_record.xpath("#{RELATED_ITEM}/#{TITLE_TEXT}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def rights_information
      if @mods_record.xpath("#{AC_USE_AND_REPRODUCTION}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{AC_USE_AND_REPRODUCTION}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif @mods_record.xpath("#{AC_RESTRICTION_ON_ACCESS}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{AC_RESTRICTION_ON_ACCESS}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif @mods_record.xpath("#{AC_DISPLAY_LABEL}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{AC_DISPLAY_LABEL}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end

    def owner
      if @mods_record.xpath("#{ROLETERM}", 'mods' => 'http://www.loc.gov/mods/v3').to_s == 'Owner'
        @mods_record.xpath("mods:name/mods:namePart[2]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s + ", " + @mods_record.xpath("mods:name/mods:namePart[1]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end
  end
end