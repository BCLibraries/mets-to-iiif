require 'iiif/presentation'
require 'metsiiif/mets_file'

module Metsiiif
  class Builder
    def initialize(iiif_host, manifest_host, image_filetype)
      @iiif_host = iiif_host
      @manifest_host = manifest_host
      @image_filetype = image_filetype
    end

    # @param mets_path [String] the METS file to convert
    def build(mets_path, descmd, structmap, sequence_div, component_div)
      mets_file = Metsiiif::MetsFile.new(mets_path, descmd, structmap, sequence_div, component_div)

      @sequence_base = "#{@iiif_host}/#{mets_file.obj_id}"
      # TODO: change sequence_base to full component label?
      # @sequence_component = "#{@iiif_host}/#{mets_file.component_label}"

      sequence = IIIF::Presentation::Sequence.new
      sequence.canvases = mets_file.struct_map.map.with_index {|comp, i| image_annotation_from_id("#{comp}.#{@image_filetype}", "#{comp}", i)}

      range = IIIF::Presentation::Range.new
      range.ranges = mets_file.struct_map.map.with_index {|comp, i| build_range("#{comp}.#{@image_filetype}", "#{comp}", i)}

      manifest = build_manifest(mets_file)
      manifest.sequences << sequence
      manifest.structures << range
      thumb = sequence.canvases.first.images.first.resource['@id'].gsub(/full\/full/, 'full/!200,200')
      manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)

      structures = manifest["structures"][0]["ranges"]
      manifest["structures"] = structures
      manifest.to_json(pretty: true)
    end

    def build_manifest(mets_file)
      if mets_file.mods.host_title == mets_file.mods.title || mets_file.mods.host_title.length == 0
        mods_title = mets_file.mods.title
      else
        mods_title = mets_file.mods.title + ', ' + mets_file.mods.host_title
      end

      seed = {
          '@id' => "#{@manifest_host}/#{mets_file.obj_id}.json",
          'label' => "#{mods_title}",
          'viewing_hint' => 'paged',
          'attribution' => "#{mets_file.mods.rights_information}",
          'metadata' => [
            {"handle": "#{mets_file.handle}"},
            {"label": "Preferred Citation", "value": "#{mets_file.mods.creator + ", " unless mets_file.mods.creator.nil?}#{mods_title}, MS.2001.039, #{mets_file.mods.owner}, #{mets_file.handle}."}
          ]
      }
      IIIF::Presentation::Manifest.new(seed)
    end

    def image_annotation_from_id(image_file, label, order)
      separator = image_file.include?('_') ? '_' : '.'
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      page_id = image_id.split(separator).last

      canvas_id = "#{@sequence_base}/canvas/#{page_id}"

      seed = {
          '@id' => "#{canvas_id}/annotation/1",
          'on' => canvas_id
      }
      annotation = IIIF::Presentation::Annotation.new(seed)
      annotation.resource = image_resource_from_page_hash(image_file)

      build_canvas(annotation, canvas_id, label)
    end

    def build_canvas(annotation, canvas_id, label)
      seed = {
          '@id' => canvas_id,
          'label' => label,
          'width' => annotation.resource['width'],
          'height' => annotation.resource['height'],
          'images' => [annotation]
      }
      IIIF::Presentation::Canvas.new(seed)
    end

    def build_range(image_file, label, order)
      separator = image_file.include?('_') ? '_' : '.'
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      page_id = image_id.split(separator).last

      range_id = "#{@sequence_base}/range/r-#{order}"
      canvas_id = "#{@sequence_base}/canvas/#{page_id}"

      seed = {
          '@id' => range_id,
          'label' => label,
          'canvases' => [canvas_id]
      }
      IIIF::Presentation::Range.new(seed)
    end

    def image_resource_from_page_hash(page_id)
      base_uri = "#{@iiif_host}/#{page_id}"
      image_api_params = '/full/full/0/default.jpg'

      params = {
          service_id: base_uri,
          resource_id_default: "#{base_uri}#{image_api_params}",
          resource_id: "#{base_uri}#{image_api_params}"
      }
      IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end
  end
end
