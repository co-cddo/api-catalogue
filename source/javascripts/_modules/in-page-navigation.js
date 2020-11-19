(function ($, Modules) {
  'use strict'

  Modules.InPageNavigation = function InPageNavigation () {
    var $tocPane
    var $contentPane
    var $tocItems
    var $targets

    this.start = function start ($element) {
      $tocPane = $element.find('.app-pane__toc')
      $contentPane = $element.find('.app-pane__content')
      $tocItems = $('.js-toc-list').find('a')
      $targets = $contentPane.find('[id]')

      $contentPane.on('scroll', _.debounce(handleScrollEvent, 100, { maxWait: 100 }))

      if (Modernizr.history) {
        // Popstate is triggered when using the back button to navigate 'within'
        // the page, i.e. changing the anchor part of the URL.
        $(window).on('popstate', function (event) {
          restoreScrollPosition(event.originalEvent.state)
        })

        if (history.state && history.state.scrollTop) {
          // Restore existing state when e.g. using the back button to return to
          // this page
          restoreScrollPosition(history.state)
        } else {
          // Store the initial position so that we can restore it even if we
          // never scroll.
          handleInitialLoadEvent()
        }
      }
    }

    function restoreScrollPosition (state) {
      if (state && typeof state.scrollTop !== 'undefined') {
        $contentPane.scrollTop(state.scrollTop)
      }
    }

    function handleInitialLoadEvent () {
      var fragment = fragmentForTargetElement()

      if (!fragment) {
        fragment = fragmentForFirstElementInView()
      }

      handleChangeInActiveItem(fragment)
    }

    function handleScrollEvent () {
      handleChangeInActiveItem(fragmentForFirstElementInView())
    }

    function handleChangeInActiveItem (fragment) {
      storeCurrentPositionInHistoryApi(fragment)
      highlightActiveItemInToc(fragment)
    }

    function storeCurrentPositionInHistoryApi (fragment) {
      if (Modernizr.history && fragment) {
        history.replaceState(
          { scrollTop: $contentPane.scrollTop() },
          '',
          fragment
        )
      }
    }

    function highlightActiveItemInToc (fragment) {
      // Navigation items for single page navigation don't necessarily include the path name, but
      // navigation items for multipage navigation items do include it. This checks for either case.
      var $activeTocItem = $tocItems.filter(
        '[href="' + window.location.pathname + fragment + '"],[href="' + fragment + '"]'
      )
      // Navigation items with children don't contain fragments in their url
      // Check to see if any nav items contain just the path name.
      if (!$activeTocItem.get(0)) {
        $activeTocItem = $tocItems.filter('[href="' + window.location.pathname + '"]')
      }
      if ($activeTocItem.get(0)) {
        $tocItems.removeClass('toc-link--in-view')
        $activeTocItem.addClass('toc-link--in-view')
        scrollTocToActiveItem($activeTocItem)
      }
    }

    function scrollTocToActiveItem ($activeTocItem) {
      var paneHeight = $tocPane.height()
      var linkTop = $activeTocItem.position().top
      var linkBottom = linkTop + $activeTocItem.outerHeight()

      var offset = null

      if (linkTop < 0) {
        offset = linkTop
      } else if (linkBottom >= paneHeight) {
        offset = -(paneHeight - linkBottom)
      } else {
        return
      }

      var newScrollTop = $tocPane.scrollTop() + offset

      $tocPane.scrollTop(newScrollTop)
    }

    function fragmentForTargetElement () {
      return window.location.hash
    }

    function fragmentForFirstElementInView () {
      var result = null

      $($targets.get().reverse()).each(function checkIfInView (index) {
        if (result) {
          return
        }

        var $this = $(this)

        if (Math.floor($this.position().top) <= 0) {
          result = $this
        }
      })

      return result ? '#' + result.attr('id') : false
    }
  }
})(jQuery, window.GOVUK.Modules)
