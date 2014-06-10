require 'spec_helper'

describe Wrapit::MethodWrappable do
  it "should add method_wrappable method when included" do
    build_class
    FooBar.private_methods.include?(:method_wrappable).should be_true
    destroy_class
  end

  def build_class
    define_class 'FooBar', 'Object' do |klass|
      klass.send :include, Wrapit::MethodWrappable
    end
  end

  def define_class(class_name, base, &block)
    eval <<-CLASS_DEF
    class ::#{class_name} < #{base}
    end
    CLASS_DEF

    klass = Object.const_get(class_name)
    klass.class_eval(&block) if block_given?
  end

  def destroy_class
    Object.send :remove_const, 'FooBar'
  end
end
