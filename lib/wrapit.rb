require 'wrapped'

require "wrapit/version"
require "wrapit/attr_wrappable"
require "wrapit/method_wrappable"

module Wrapit
  class InvalidCallerError < StandardError; end
end
