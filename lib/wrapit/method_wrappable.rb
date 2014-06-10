module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
        class_eval do
          args.each do |method|
            define_method method do
              super().wrapped
            end
          end
        end
      end
    end
  end
end
