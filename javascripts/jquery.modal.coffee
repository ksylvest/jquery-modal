###
jQuery Modal
Copyright 2013 Kevin Sylvestre
1.1.3
###

"use strict"

$ = jQuery

class Animation
  @transitions:
    "webkitTransition": "webkitTransitionEnd"
    "mozTransition": "mozTransitionEnd"
    "oTransition": "oTransitionEnd"
    "transition": "transitionend"

  @transition: ($el) ->
    el = $el[0]
    return result for type, result of @transitions when el.style[type]?

  @execute: ($el, callback) ->
    transition = @transition($el)
    if transition? then $el.one(transition, callback) else callback()

  @hide: ($el, klass = 'fade') ->
    $el.addClass(klass)

  @show: ($el, klass = 'fade')->
    $el.removeClass(klass)

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
    $(document)[method] 'keyup', @keyup
    @$vignette[method] 'click', @close
    @$modal[method] 'click', '[data-dismiss="modal"]', @close

  hide: =>
    alpha = => @toggle('off')
    omega = =>
      @$modal.trigger('hidden')
      @$vignette.remove()
      @$modal.hide()

    alpha()
    @vignette('hide')
    @modal('hide', omega)

  show: =>
    omega = => @toggle('on')
    alpha = => 
      @$modal.trigger('shown')
      $(document.body).append(@$vignette)
      @$modal.show()

    alpha()
    @vignette('show')
    @modal('show', omega)

  modal: (method, callback) ->
    @$vignette.position()
    Animation[method](@$modal)
    Animation.execute(@$modal, callback) if callback?

  vignette: (method, callback) ->
    @$vignette.position()
    Animation[method](@$vignette)
    Animation.execute(@$vignette, callback) if callback?

$.fn.extend
  modal: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.modal.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action
      action ?= "show"

      Modal.modal($this, options)[action]()
