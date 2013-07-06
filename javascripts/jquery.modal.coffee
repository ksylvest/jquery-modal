###
jQuery Modal
Copyright 2013 Kevin Sylvestre
v1.0.1
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
    if transition? then $el.one(transition, callback) else callback?()

class Modal

  @modal: ($el, options = {}) ->
    data = $el.data('modal')
    unless data
      data = new Modal($el, options)
      $el.data('modal', data)
    return data

  $: (selector) =>
    @$modal.find(selector)

  constructor: ($el, settings = {}) ->
    @$el = $el
    @$vignette = $("<div class='vignette'></div>")
    $(document.body).append(@$vignette)

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
    @$el[method] 'click', '[data-dismiss="modal"]', @close

  setup: =>
    @toggle('on')

  clear: =>
    @toggle('off')

  hide: =>
    alpha = @clear
    omega = =>
      @$vignette.hide()
      @$el.hide()

    alpha()
    @$el.position()
    @$el.addClass('fade')
    Animation.execute(@$el, omega)

  show: =>
    omega = @setup
    alpha = => 
      @$vignette.show()
      @$el.show()

    alpha()

    @$el.addClass('fade')
    @$el.position()
    @$el.removeClass('fade')
    Animation.execute(@$el, omega)

$.fn.extend
  modal: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.modal.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action
      action ?= "show"

      Modal.modal($this, options)[action]()
