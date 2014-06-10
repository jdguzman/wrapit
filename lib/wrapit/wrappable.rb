module Wrapit::Wrappable
  def self.included(base)
    class << base
      private

      def attr_wrappable(*args)
        attr_accessor *args.map { |m| "#{m.to_s}_naked".to_sym }
      end

      def wrap_attribute(*args)
      end
    end
  end
end
