(function ($, Modules) {
  'use strict'

  Modules.CollapsibleNavigation = function () {
    var $contentPane
    var $nav
    var $topLevelItems

    this.start = function ($element) {
      $contentPane = $('.app-pane__content')
      $nav = $element
      $topLevelItems = $nav.find('> ul > li')

      // Attach collapsible heading functionality,on mobile and desktop
      collapsibleHeadings()
      openActiveHeading()
      $contentPane.on('scroll', _.debounce(openActiveHeading, 100, { maxWait: 100 }))
    }

    function collapsibleHeadings () {
      for (var i = $topLevelItems.length - 1; i >= 0; i--) {
        var $topLevelItem = $($topLevelItems[i])
        var $heading = $topLevelItem.find('> a')
        var $listing = $topLevelItem.find('> ul')
        var id = 'toc-' + $heading.text().toLowerCase().replace(/\s+/g, '-')
        // Only add collapsible functionality if there are children.
        if ($listing.length === 0) {
          continue
        }
        $topLevelItem.addClass('collapsible')
        var arrayOfIds = []
        $listing.each(function (i) {
          var uniqueId = id + '-' + i
          arrayOfIds.push(uniqueId)
          $(this).addClass('collapsible__body')
            .attr('id', uniqueId)
            .attr('aria-expanded', 'false')
        })
        $heading.addClass('collapsible__heading')
          .after('<button class="collapsible__toggle" aria-controls="' + arrayOfIds.join(' ') + '"><span class="collapsible__toggle-label">Expand ' + $heading.text() + '</span><span class="collapsible__toggle-icon" aria-hidden="true"></button>')
        $topLevelItem.on('click', '.collapsible__toggle', function (e) {
          e.preventDefault()
          var $parent = $(this).parent()
          toggleHeading($parent)
        })
      }
    }

    function toggleHeading ($topLevelItem) {
      var isOpen = $topLevelItem.hasClass('is-open')
      var $heading = $topLevelItem.find('> a')
      var $body = $topLevelItem.find('.collapsible__body')
      var $toggleLabel = $topLevelItem.find('.collapsible__toggle-label')

      $topLevelItem.toggleClass('is-open', !isOpen)
      $body.attr('aria-expanded', isOpen ? 'false' : 'true')
      $toggleLabel.text(isOpen ? 'Expand ' + $heading.text() : 'Collapse ' + $heading.text())
    }

    function openActiveHeading () {
      var $activeElement
      var currentPath = window.location.pathname
      var isActiveTrail = '[href*="' + currentPath + '"]'
      // Add an exception for the root page, as every href includes /
      if (currentPath === '/') {
        isActiveTrail = '[href="' + currentPath + window.location.hash + '"]'
      }
      for (var i = $topLevelItems.length - 1; i >= 0; i--) {
        var $element = $($topLevelItems[i])
        var $heading = $element.find('> a')
        // Check if this item href matches
        if ($heading.is(isActiveTrail)) {
          $activeElement = $element
          break
        }
        // Otherwise check the children
        var $children = $element.find('li > a')
        var $matchingChildren = $children.filter(isActiveTrail)
        if ($matchingChildren.length) {
          $activeElement = $element
          break
        }
      }
      if ($activeElement && !$activeElement.hasClass('is-open')) {
        toggleHeading($activeElement)
      }
    }
  }
})(jQuery, window.GOVUK.Modules)
