require 'spec_helper'

describe Wrapit::Wrappable do
  it "should add attr_wrappable method when included" do
    build_class
    FooBar.respond_to?(:attr_wrappable).should be_true
    destroy_class
  end

  it "should add wrap_attribute method when included" do
    build_class
    FooBar.respond_to?(:wrap_attribute).should be_true
    destroy_class
  end

  def build_class
    define_class 'FooBar', 'Object' do |klass|
      klass.send :include, Wrapit::Wrappable
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
