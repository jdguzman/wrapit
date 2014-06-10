require 'spec_helper'

describe Wrapit::MethodWrappable do
  it "should add method_wrappable method when included" do
    build_class
    FooBar.private_methods.include?(:method_wrappable).should be_true
    destroy_class
  end

  it "should add _naked version of method with method_wrappable" do
    build_class
    FooBar.module_eval { method_wrappable :to_s }
    FooBar.new.respond_to?(:to_s_naked).should be_true
    destroy_class
  end

  it "should create a wrapped version of method with method_wrappable" do
    build_class
    FooBar.module_eval { method_wrappable :to_s }
    FooBar.new.to_s.should be_kind_of Present
    destroy_class
  end

  it "wrapped method should return instance of Blank when nil returned" do
    build_class
    FooBar.module_eval { define_method :test_method do nil; end }
    FooBar.module_eval { method_wrappable :test_method }
    FooBar.new.test_method.should be_kind_of Blank
    destroy_class
  end

  it "wrapped method should return instance of Present when anything other than nil is returned" do
    build_class
    FooBar.module_eval { define_method :test_method do "something"; end }
    FooBar.module_eval { method_wrappable :test_method }
    FooBar.new.test_method.should be_kind_of Present
    destroy_class
  end

  it "wrapped method and _naked method should return same value" do
    build_class
    FooBar.module_eval { define_method :test_method do "something"; end }
    FooBar.module_eval { method_wrappable :test_method }
    foo_bar = FooBar.new
    foo_bar.test_method.unwrap.should eq foo_bar.test_method_naked
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
