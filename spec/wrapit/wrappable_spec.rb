require 'spec_helper'

describe Wrapit::Wrappable do
  it "should add attr_wrappable method when included" do
    build_class
    FooBar.private_methods.include?(:attr_wrappable).should be_true
    destroy_class
  end

  it "should add wrap_attribute method when included" do
    build_class
    FooBar.private_methods.include?(:wrap_attribute).should be_true
    destroy_class
  end

  it "should add attribute reader/writers with attr_wrappable" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    FooBar.new.respond_to?(:test_method).should be_true
    FooBar.new.respond_to?(:test_method=).should be_true
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
