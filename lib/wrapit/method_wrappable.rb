module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
      end
    end
  end
end
