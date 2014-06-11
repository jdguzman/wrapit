module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
        args.each do |method|
          mw_create_naked_method(method)
          mw_create_wrapped_method(method)
        end
      end

      def mw_create_naked_method(method)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /method_wrappable/

        define_method :"#{method}_naked" do |*args|
          self.class.superclass.instance_method(method).bind(self).call(*args)
        end
      end

      def mw_create_wrapped_method(method)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /method_wrappable/

        define_method method do |*args|
          super(*args).wrapped
        end
      end
    end
  end
end
