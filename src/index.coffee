
class BindingsDecorator

  ###
  ###

  constructor: (@target, options) ->
    @bindings = if typeof options is "object" then options else undefined

  ###
  ###

  bind: () =>
    @_setupExplicitBindings() if @bindings

  ###
   explicit bindings are properties from & to properties of the view controller
  ###

  _setupExplicitBindings: () ->
    bindings = @bindings
    @_setupBinding key, bindings[key] for key of bindings

  ###
  ###

  _setupBinding: (property, to) ->

    options = {}

    if typeof to is "function" 
      oldTo = to
      to = () =>
        oldTo.apply @view, arguments

    if to.to
      options = to
    else
      options = { to: to }


    options.property = property
    @target.bind(options).now()


module.exports = (event) ->
  options: (target) -> target.bindings
  decorate: (target, options) ->
    decor = new BindingsDecorator target, options

    # event? wait for it.
    if event
      target.once event, decor.bind

    # otherwise, bind immediately
    else
      decor.bind()
