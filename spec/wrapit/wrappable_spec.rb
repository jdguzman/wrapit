require 'spec_helper'

describe Wrapit::Wrappable do
  it "should add attr_wrappable method when included" do
    define_class 'FooBar', 'Object' do |klass|
      klass.send :include, Wrapit::Wrappable
    end

    FooBar.respond_to?(:attr_wrappable).should be_true
    undef_class 'FooBar'
  end

  it "should add wrap_attribute method when included" do
    define_class 'FooBar', 'Object' do |klass|
      klass.send :include, Wrapit::Wrappable
    end

    FooBar.respond_to?(:wrap_attribute).should be_true
    undef_class 'FooBar'
  end

  def define_class(class_name, base, &block)
    eval <<-CLASS_DEF
    class ::#{class_name} < #{base}
    end
    CLASS_DEF

    klass = Object.const_get(class_name)
    klass.class_eval(&block) if block_given?
  end

  def undef_class(class_name)
    Object.send :remove_const, class_name
  end
end
