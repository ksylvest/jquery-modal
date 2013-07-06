###
jQuery Modal
Copyright 2013 Kevin Sylvestre
1.0.4
###

"use strict"

$ = jQuery

class Animation
  @transitions:
    "webkitTransition": "webkitTransitionEnd"
    "mozTransition": "mozTransitionEnd"
    "msTransition": "msTransitionEnd"
    "oTransition": "oTransitionEnd"
    "transition": "transitionend"

  @transition: ($el) ->
    el = $el[0]
    return result for type, result of @transitions when el.style[type]?

  @execute: ($el, callback) ->
    transition = @transition($el)
    if transition? then $el.one(transition, callback) else callback()

class Modal

  @modal: ($el, options = {}) ->
    data = $el.data('modal')
    unless data
      data = new Modal($el, options)
      $el.data('modal', data)
    return data

  $: (selector) =>
    @$modal.find(selector)

  constructor: ($modal, settings = {}) ->
    @$modal = $modal
    @$vignette = $("<div class='vignette fade'></div>")
    $(document.body).append(@$vignette)

  remove: =>
    @$modal.remove()
    @$vignette.remove()

  close: (event) =>
    event?.preventDefault()
    event?.stopPropagation()
    @hide()

  keyup: (event) =>
    return if event.target.form?
    @close() if event.which is 27 # esc

  toggle: (method = 'on') =>
    $(document)[method] "keyup", @keyup
    @$vignette[method] "click", @close
    @$modal[method] 'click', '[data-dismiss="modal"]', @close

  hide: =>
    alpha = => @toggle('off')
    omega = =>
      @$vignette.hide()
      @$modal.hide()

    alpha()
    @hideModal(=> @hideVignette(omega))

  show: =>
    omega = => @toggle('on')
    alpha = => 
      @$vignette.show()
      @$modal.show()

    alpha()
    @showVignette(=> @showModal(omega))

  showModal: (callback) =>
    @$modal.addClass('fade')
    @$modal.position()
    @$modal.removeClass('fade')
    Animation.execute(@$modal, callback) if callback?

  hideModal: (callback) =>
    @$modal.removeClass('fade')
    @$modal.position()
    @$modal.addClass('fade')
    Animation.execute(@$modal, callback) if callback?

  showVignette: (callback) =>
    @$vignette.addClass('fade')
    @$vignette.position()
    @$vignette.removeClass('fade')
    Animation.execute(@$vignette, callback) if callback?

  hideVignette: (callback) =>
    @$vignette.removeClass('fade')
    @$vignette.position()
    @$vignette.addClass('fade')
    Animation.execute(@$vignette, callback) if callback?

$.fn.extend
  modal: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.modal.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action
      action ?= "show"

      Modal.modal($this, options)[action]()
