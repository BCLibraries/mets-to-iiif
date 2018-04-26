require 'yaml'

module Metsiiif
  class Config
    attr_reader :cnf
    @cnf = YAML::load_file(File.join(__dir__, '/config.yml'))
    def self.cnf
      @cnf
    end
  end
end