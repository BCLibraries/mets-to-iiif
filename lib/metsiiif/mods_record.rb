module Metsiiif
  class ModsRecord
    # @param [Nokogiri::XML::Node] mods_record
    def initialize(mods_record, title, relateditem, accession_number, roleterm, 
                   useandreproduction, restrictiononaccess, conditions_governing_use_note)
      @mods_record = mods_record
      @title = title
      @relateditem = relateditem
      @accession_number = accession_number
      @roleterm = roleterm
      @useandreproduction = useandreproduction
      @restrictiononaccess = restrictiononaccess
      @conditions_governing_use_note = conditions_governing_use_note
    end

    def title
      @mods_record.xpath("#{@title}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def host_title
      @mods_record.xpath("#{@relateditem}/#{@title}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
    end

    def rights_information
      if @mods_record.xpath("#{@useandreproduction}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{@useandreproduction}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif @mods_record.xpath("#{@restrictiononaccess}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{@restrictiononaccess}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      elsif @mods_record.xpath("#{@conditions_governing_use_note}", 'mods' => 'http://www.loc.gov/mods/v3').to_s.length > 0
        @mods_record.xpath("#{@conditions_governing_use_note}", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end

    def owner
      if @mods_record.xpath("#{@roleterm}", 'mods' => 'http://www.loc.gov/mods/v3').to_s == 'Owner'
        @mods_record.xpath("mods:name/mods:namePart[2]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s + ", " + @mods_record.xpath("mods:name/mods:namePart[1]/text()", 'mods' => 'http://www.loc.gov/mods/v3').to_s
      end
    end
  end
end