module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
        args.each do |method|
          has_args = (instance_method(method).arity != 0)
          mw_create_naked_method(method, has_args)
          mw_create_wrapped_method(method, has_args)
        end
      end

      def mw_create_naked_method(method, has_args)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /method_wrappable/

        if has_args
          define_method :"#{method}_naked" do |*args|
            self.class.superclass.instance_method(method).bind(self).call(*args)
          end
        else
          define_method :"#{method}_naked" do
            self.class.superclass.instance_method(method).bind(self).call
          end
        end
      end

      def mw_create_wrapped_method(method, has_args)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /method_wrappable/

        if has_args
          define_method method do |*args|
            super(*args).wrapped
          end
        else
          define_method method do
            super().wrapped
          end
        end
      end
    end
  end
end
