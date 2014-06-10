require 'spec_helper'

describe Wrapit::AttrWrappable do
  it "should add attr_wrappable method when included" do
    build_class
    FooBar.private_methods.include?(:attr_wrappable).should be_true
    destroy_class
  end

  it "should add _naked attribute reader/writers with attr_wrappable" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    FooBar.new.respond_to?(:test_method_naked).should be_true
    FooBar.new.respond_to?(:test_method_naked=).should be_true
    destroy_class
  end

  it "should create a wrapped reader with attr_wrappable" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    FooBar.new.test_method.should be_kind_of Blank
    destroy_class
  end

  it "attr_wrappable should return instance of Blank when attribute nil" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    foo_bar = FooBar.new
    foo_bar.test_method = nil
    foo_bar.test_method.should be_kind_of Blank
    destroy_class
  end

  it "attr_wrappable should return instance of Present when attribute not nil" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    foo_bar = FooBar.new
    foo_bar.test_method = "something"
    foo_bar.test_method.should be_kind_of Present
    destroy_class
  end

  it "attr_wrappable _naked and wrapped readers should return same value" do
    build_class
    FooBar.module_eval { attr_wrappable :test_method }
    foo_bar = FooBar.new
    foo_bar.test_method = "something"
    foo_bar.test_method.unwrap.should eq foo_bar.test_method_naked
    destroy_class
  end

  def build_class
    define_class 'FooBar', 'Object' do |klass|
      klass.send :include, Wrapit::AttrWrappable
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
