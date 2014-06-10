module Wrapit::AttrWrappable
  def self.included(base)
    class << base
      private

      def attr_wrappable(*args)
        attr_accessor *args.map { |m| "#{m.to_s}_naked".to_sym }

        args.each do |method|
          define_method method do
            send(:"#{method}_naked").wrapped
          end

          define_method :"#{method}=" do |value|
            send(:"#{method}_naked=", value)
          end
        end
      end
    end
  end
end
