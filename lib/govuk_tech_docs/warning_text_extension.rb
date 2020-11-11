module GovukTechDocs
  class WarningTextExtension < Middleman::Extension
    def initialize(app, options_hash = {}, &block)
      super
    end

    helpers do
      def warning_text(text)
        <<~EOS
        <div class="govuk-warning-text">
          <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
          <strong class="govuk-warning-text__text">
            <span class="govuk-warning-text__assistive">Warning</span>
            #{text}
          </strong>
        </div>
        EOS
      end
    end
  end
end

::Middleman::Extensions.register(:warning_text, GovukTechDocs::WarningTextExtension)
