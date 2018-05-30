require 'optparse'
require 'yaml'

module Metsiiif
  class Opts
    attr_reader :options, :cnf

    def self.parse(args)
      @options = OpenStruct.new
      @options.library = []
      @options.inplace = false
      @options.encoding = "utf8"
      @options.transfer_type = :auto
      @options.verbose = false

      opt_parser = OptionParser.new do |parser|
        parser.banner = "Usage: metsiiif [options] /path/to/mets"

        parser.on("-c", "--config PATH", String, "Set config file") do |path|
          @options.config_file = path
        end

        parser.on("-h", "--help", "Show this help message") do
          puts parser
          exit
        end
      end

      opt_parser.parse!(args)
    end

    def self.cnf
      if @options.config_file
        @cnf = YAML::load_file(@options.config_file)
      else
        @cnf = YAML::load_file(File.join(__dir__, '../../config.yml'))
      end
    end

  end
end