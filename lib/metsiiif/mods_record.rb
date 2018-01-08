module Metsiiif
  class ModsRecord

    TITLE_TEXT = 'mods:titleInfo[@usage="primary"]/mods:title/text()'

    RELATED_ITEM = 'mods:relatedItem[@type="host"]'

    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record)
      @mods_record = mods_record
    end

    def title
      @mods_record.xpath("mods:mods/#{TITLE_TEXT}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def host_title
      @mods_record.xpath("mods:mods/#{RELATED_ITEM}/#{TITLE_TEXT}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end
  end
end
