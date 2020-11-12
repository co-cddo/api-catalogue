require "erb"
require "openapi3_parser"
require "uri"
require_relative "api_reference_renderer"

module GovukTechDocs
  module ApiReference
    class Extension < Middleman::Extension
      expose_to_application api: :api

      def initialize(app, options_hash = {}, &block)
        super

        @app = app
        @config = @app.config[:tech_docs]

        # If no api path then just return.
        if @config["api_path"].to_s.empty?
          @api_parser = false
          return
        end

        # Is the api_path a url or path?
        if uri?(@config["api_path"])
          @api_parser = true
          @document = Openapi3Parser.load_url(@config["api_path"])
        elsif File.exist?(@config["api_path"])
          # Load api file and set existence flag.
          @api_parser = true
          @document = Openapi3Parser.load_file(@config["api_path"])
        else
          @api_parser = false
          raise "Unable to load api path from tech-docs.yml"
        end
        @render = Renderer.new(@app, @document)
      end

      def uri?(string)
        uri = URI.parse(string)
        %w[http https].include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

      def api(text)
        if @api_parser == true

          keywords = {
            "api&gt;" => "default",
            "api_schema&gt;" => "schema",
          }

          regexp = keywords.map { |k, _| Regexp.escape(k) }.join("|")

          md = text.match(/^<p>(#{regexp})/)
          if md
            key = md.captures[0]
            type = keywords[key]

            text.gsub!(/#{Regexp.escape(key)}\s+?/, "")

            # Strip paragraph tags from text
            text = text.gsub(/<\/?[^>]*>/, "")
            text = text.strip

            if text == "api&gt;"
              @render.api_full(api_info, api_servers)
            elsif type == "default"
              output = @render.path(text)
              # Render any schemas referenced in the above path
              output += @render.schemas_from_path(text)
              output
            else
              @render.schema(text)
            end

          else
            text
          end
        else
          text
        end
      end

    private

      def api_info
        @document.info
      end

      def api_servers
        @document.servers
      end
    end
  end
end

::Middleman::Extensions.register(:api_reference, GovukTechDocs::ApiReference::Extension)
