module GovukTechDocs
  class UniqueIdentifierExtension < Middleman::Extension
    def initialize(app, options_hash = {}, &block)
      super

      app.before do
        UniqueIdentifierGenerator.instance.reset
      end
    end
  end
end

::Middleman::Extensions.register(:unique_identifier, GovukTechDocs::UniqueIdentifierExtension)
