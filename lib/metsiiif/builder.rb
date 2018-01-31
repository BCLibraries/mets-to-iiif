require 'iiif/presentation'
require 'metsiiif/mets_file'

module Metsiiif

  class Builder

    def initialize (iiif_host, manifest_host)
      @iiif_host = iiif_host
      @manifest_host = manifest_host
    end

    # @param mets_path [String] the METS file to convert
    def build(mets_path)
      mets_file = Metsiiif::MetsFile.new(mets_path)

      @sequence_base = "#{@iiif_host}/#{mets_file.sequence_label}"

      sequence = IIIF::Presentation::Sequence.new
      sequence.canvases = mets_file.struct_map.map.with_index {|comp, i| image_annotation_from_id("#{comp}.jp2", "#{comp}", i)}

      range = IIIF::Presentation::Range.new
      range.ranges = mets_file.struct_map.map.with_index {|comp, i| build_range("#{@sequence_base}/canvases/#{page_id}", "#{comp}", i)}

      manifest = build_manifest(mets_file)
      manifest.sequences << sequence
      manifest.structures << range
      thumb = sequence.canvases.first.images.first.resource['@id']
      manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)

      manifest.to_json(pretty: true)
    end

    def build_manifest(mets_file)
      seed = {
          '@id' => "#{@manifest_host}/#{mets_file.obj_id}.json",
          'label' => "#{mets_file.mods.host_title} #{mets_file.mods.title}",
          'viewing_hint' => 'paged',
          'description' => 'Longer description of item.'
      }
      IIIF::Presentation::Manifest.new(seed)
    end

    def image_annotation_from_id(image_file, label, order)
      separator = image_file.include?('_') ? '_' : '.'
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff')
      page_id = image_id.split(separator).last

      canvas_id = "#{@sequence_base}/canvases/#{page_id}"

      seed = {
          '@id' => "#{canvas_id}/annotations/1",
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

    def build_range(canvas_id, label, order)
      range_id = "#{@sequence_base}/ranges/r-#{order}"

      seed = {
          '@id' => range_id,
          'label' => label,
          'canvases' => "[#{canvas_id}]"
      }
      IIIF::Presentation::Range.new(seed)
    end

    def image_resource_from_page_hash(page_id)
      base_uri = "#{@iiif_host}/#{page_id}"
      params = {service_id: base_uri}
      IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end
  end
end
