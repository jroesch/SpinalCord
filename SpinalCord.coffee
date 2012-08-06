# SpinalCord.js
#
# Requires jQuery, Underscore.js, and Backbone.js
#
# An extension to Backbone.js hence SpinalCord.js
# 
# Builds upon the functionality of Backbone by adding more built-in classes, and features.
# 
# The current list includes:
#   - Error Reporting, baked into Views (à la Rails' flash) (SpinalCord.ErrorView)
#
#   - Layouts, a way of wrapping a view in a default context that surronds the generated
#     view, insures the view contains the correct static content, but allows it to be redrawn
#     without worry.
#
#   - Authenticated Models and Collections, a simple way of ensuring HTTP Basic Auth credentials 
#     are always attached to fetch() requests, and therefore passed all the way down to Backbone.sync()
#
#   - Utility Functions
#
#   - Enhancements to Routing, allowing for greater freedom in controlling the flow of the 
#   - Application in the form of SpinalCord.Application
#
#   - User Model, a simple user model that provides integrated authentication, just
#     provide the isAuth function.
#
#   (c) July 2012 Jared Roesch, Zentopy Inc.
#   SpinalCord may be freely distributed under the MIT license.
#   For all details and documentation:
#   <insert site here>

# Global hoisting borrowed from Backbone
root = this

# The top-level namespace. All public SpinalCord classes and modules will
# be attached to this. Exported for both CommonJS and the browser.
if (typeof exports isnt 'undefined')
  SpinalCord = exports
else
  SpinalCord = root.SpinalCord = _.extend({}, Backbone);

SpinalCord.VERSION = '0.0.1-ALPHA'

# Attach a Cookie Object that Provides a convienient abstraction to the cookie
SpinalCord.Cookie = (key, value, options) ->
  # Set up encode, and decode functions
  options = $.extend({}, options)
  id = (s) -> s
  encode = encodeURIComponent
  decode = if options.raw then id else decodeURIComponent
    
  serializeCookie = (c) -> [
    encode(key), '=', 
    if options.raw then value else encode value,
    if options.expires then '; expires=' + options.expires.toUTCString() else '',
    if options.path then '; path=' + options.path else '',
    if options.domain then '; domain=' + options.domain else '',
    if options.secure then '; secure' else ''
  ].join ''
  
  # Returns an object that consists of the parsed cookie
  readCookie = -> 
    pairs = document.cookie.split('; ');
    cookieObj = {} 
    
    for each in pairs
      pair = each.split("=")
      newKey = decode(pair[0])
      newValue = decode(pair[1]) || ""
      cookieObj[newKey] = newValue
      
    cookieObj
  
  # Function Logic begins here.
  cookie = readCookie()
  
  # Not sure if expiration works
  # We need a more granular expiry time 
  if options? and options.expires?
    days = options.expires 
    t = options.expires = new Date()
    t.setDate(t.getDate() + days)

  if key?
    if value?
      cookie[key] = String(value)
      document.cookie = serializeCookie(cookie)
      document.cookie
    else
      cookie[key]
  else
    undefined 
    
authFetch = (options) ->
  user = SpinalCord.getUser().toJSON()
  options = _.extend(options, user)
  super options

SpinalCord.Auth = {}

class SpinalCord.Auth.Model extends Backbone.Model
  fetch: authFetch
  
class SpinalCord.Auth.Collection extends Backbone.Collection
  fetch: authFetch
  
#class SpinalCord.User 
  # user impl. here

# looks for <%= yield %>, to subsitute subview 
# things are not that clear still
###
class SpinalCord.Layout 
  constructor: (@template) ->
   
  wrapWithLayout: (view) ->
    renderer = -> 
      @template yield: view.render()
###

# Better Dispatch aganist different View types  
###
class SpinalCord.View extends Backbone.View
  initialize(options) ->
    if (layout = options.withLayout)?
      @render = layout.wrapWithLayout(this)
###
      
#class SpinalCord.ErrorView extends Backbone.View
  
#class SpinalCord.Application extends Backbone.Router 
  
SpinalCord.run = (app) ->
  #set up running app
  
  
      



