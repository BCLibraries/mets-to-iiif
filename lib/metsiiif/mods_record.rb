module Metsiiif
  class ModsRecord

    TITLE_TEXT = 'mods:titleInfo[@usage="primary"]/mods:title/text()'
    RELATED_ITEM = 'mods:relatedItem[@type="host"]'
    ABSTRACT = 'mods:mods/mods:abstract'

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
      if AC_USE_AND_REPRODUCTION.length > 0
        @mods_record.xpath("#{AC_USE_AND_REPRODUCTION}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif AC_RESTRICTION_ON_ACCESS.length > 0
        @mods_record.xpath("#{AC_RESTRICTION_ON_ACCESS}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif AC_DISPLAY_LABEL.length > 0
        @mods_record.xpath("#{AC_DISPLAY_LABEL}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end
  end
end