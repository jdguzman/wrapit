module Wrapit::Wrappable
  module ClassMethods
    def attr_wrappable(*args)

    end

    def wrap_attribute(*args)

    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
