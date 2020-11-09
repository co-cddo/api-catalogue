(function ($) {
  function trackLinkClick (action, $element) {
    var linkText = $.trim($element.text())
    var linkURL = $element.attr('href')
    var label = linkText + '|' + linkURL

    ga(
      'send',
      'event',
      'SM Technical Documentation', // Event Category
      action, // Event Action
      label // Event Label
    )
  }

  function linkTrackingEventHandler (action) {
    return function () {
      trackLinkClick(action, $(this))
    }
  }

  function catchBrokenFragmentLinks () {
    var fragment = window.location.hash
    var $target = $(fragment)
    if (!$target.get(0)) {
      ga(
        'send',
        'event',
        'Broken fragment ID', // Event Category
        'pageview', // Event Action
        window.location.pathname + fragment // Event Label
      )
    }
  }

  $(document).on('ready', function () {
    if (typeof ga === 'undefined') {
      return
    }

    $('.technical-documentation a').on('click', linkTrackingEventHandler('inTextClick'))
    $('.header a').on('click', linkTrackingEventHandler('topNavigationClick'))
    $('.toc a').on('click', linkTrackingEventHandler('tableOfContentsNavigationClick'))
    catchBrokenFragmentLinks()

    // Borrowed from:
    // https://github.com/alphagov/govuk_frontend_toolkit/blob/master/javascripts/govuk/analytics/analytics.js
    window.stripPIIFromString = function (string) {
      var EMAIL_PATTERN = /[^\s=/?&]+(?:@|%40)[^\s=/?&]+/g
      var POSTCODE_PATTERN = /[A-PR-UWYZ][A-HJ-Z]?[0-9][0-9A-HJKMNPR-Y]?(?:[\s+]|%20)*[0-9][ABD-HJLNPQ-Z]{2}/gi
      var DATE_PATTERN = /\d{4}(-?)\d{2}(-?)\d{2}/g
      var stripped = string.replace(EMAIL_PATTERN, '[email]')
        .replace(DATE_PATTERN, '[date]')
        .replace(POSTCODE_PATTERN, '[postcode]')
      return stripped
    }
  })
})(jQuery)
