module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
        args.each do |method|
          define_method :"#{method}_naked" do
            self.class.superclass.instance_method(method).bind(self).call
          end

          define_method method do
            super().wrapped
          end
        end
      end
    end
  end
end
