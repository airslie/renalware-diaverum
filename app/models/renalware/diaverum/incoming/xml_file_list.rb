# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class XmlFileList
        pattr_initialize :logger, :pattern

        def each_file
          logger.info "Ingesting Diaverum HD Sessions using pattern #{pattern}"
          Dir.glob(pattern).sort.each do |filepath|
            filename = File.basename(filepath)
            yield(filepath, filename) if block_given?
          end
        end
      end
    end
  end
end
