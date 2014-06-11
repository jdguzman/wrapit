module Wrapit::AttrWrappable
  def self.included(base)
    class << base
      private

      def attr_wrappable(*args)
        attr_accessor *args.map { |m| "#{m.to_s}_naked".to_sym }

        args.each do |method|
          aw_create_naked_method(method)
          aw_create_wrapped_method(method)
        end
      end

      def aw_create_naked_method(method)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /attr_wrappable/
        define_method method do
          send(:"#{method}_naked").wrapped
        end
      end

      def aw_create_wrapped_method(method)
        raise Wrapit::InvalidCallerError unless caller[0] =~ /attr_wrappable/
        define_method :"#{method}=" do |value|
          send(:"#{method}_naked=", value)
        end
      end
    end
  end
end
