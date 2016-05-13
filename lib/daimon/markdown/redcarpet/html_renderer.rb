require "rouge/plugins/redcarpet"

module Daimon
  module Markdown
    module Redcarpet
      class HTMLRenderer < ::Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet

        def initialize(extensions = {})
          super
          @plugins = []
        end

        def preprocess(full_document)
          full_document.scan(/{{.+?}}/) do |m|
            @plugins << m
          end
        end

        def postprocess(full_document)
          document = ""
          scanner = StringScanner.new(full_document)
          loop do
            if scanner.match?(/{{.+?}}/)
              document << @plugins.shift
              scanner.pos += scanner.matched_size
            else
              document << scanner.getch
            end
            break if scanner.eos?
          end
          document
        end
      end
    end
  end
end
