(function ($, Modules) {
  'use strict'

  Modules.AnchoredHeadings = function () {
    this.start = function ($element) {
      var headings = $element.find('h1, h2, h3, h4, h5, h6')
      headings.each(injectAnchor)
    }

    function injectAnchor () {
      var $this = $(this)
      $this.addClass('anchored-heading')
      $this.prepend(
        '<a href="#' + $this.attr('id') + '" class="anchored-heading__icon" aria-hidden="true" tabindex="-1"></a>'
      )
    }
  }
})(jQuery, window.GOVUK.Modules)
