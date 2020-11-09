(function ($, Modules) {
  'use strict'

  Modules.Navigation = function () {
    var $html = $('html')

    var $navToggle
    var $nav

    this.start = function ($element) {
      $navToggle = $('.js-nav-toggle', $element)
      $nav = $('.js-nav', $element)

      updateAriaAttributes()

      $navToggle.on('click', toggleNavigation)
      $(window).on('resize', updateAriaAttributes)
    }

    function updateAriaAttributes () {
      var navIsVisible = $nav.is(':visible')

      $navToggle.attr('aria-expanded', navIsVisible ? 'true' : 'false')
      $nav.attr('aria-hidden', navIsVisible ? 'false' : 'true')
    }

    function toggleNavigation () {
      var navIsVisible = !$html.hasClass('nav-open')

      $html.toggleClass('nav-open', navIsVisible)
      updateAriaAttributes()
    }
  }
})(jQuery, window.GOVUK.Modules)
