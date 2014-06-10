module Wrapit::MethodWrappable
  def self.included(base)
    class << base
      private

      def method_wrappable(*args)
        args.each do |method|
          alias_method :"#{method}_naked", method

          define_method method do
            send("#{method}_naked").wrapped
          end
        end
      end
    end
  end
end
