(function ($, Modules) {
  'use strict'

  Modules.PageExpiry = function PageExpiry () {
    this.start = function start ($element) {
      var rawDate = $element.data('last-reviewed-on')
      var isExpired = Date.parse(rawDate) < new Date()

      if (isExpired) {
        $element.find('.page-expiry--not-expired').hide(0)
        $element.find('.page-expiry--expired').show(0)
      }
    }
  }
})(jQuery, window.GOVUK.Modules)
