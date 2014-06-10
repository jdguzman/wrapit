module Wrapit::Wrappable
  def self.included(base)
    class << base
      private

      def attr_wrappable(*args)
      end

      def wrap_attribute(*args)
      end
    end
  end
end
