require 'spec_helper'

describe Wrapit::MethodWrappable do
  it "should add method_wrappable method when included" do
    build_class
    expect(FooBar.private_methods.include?(:method_wrappable)).to be true
    destroy_class
  end

  it "should add _naked attribute reader with method_wrappable" do
    build_class
    FooBar.module_eval { method_wrappable :to_s }
    expect(FooBar.new.respond_to?(:to_s_naked)).to be true
    destroy_class
  end

  it "should create a wrapped version of method with method_wrappable" do
    build_class
    FooBar.module_eval { method_wrappable :to_s }
    expect(FooBar.new.to_s).to be_kind_of Present
    destroy_class
  end

  it "wrapped method should return instance of Blank when nil returned" do
    build_class
    Object.module_eval { define_method :test_method do nil; end }
    FooBar.module_eval { method_wrappable :test_method }
    expect(FooBar.new.test_method).to be_kind_of Blank
    destroy_class
  end

  it "wrapped method should return instance of Present when anything other than nil is returned" do
    build_class
    Object.module_eval { define_method :test_method do "something"; end }
    FooBar.module_eval { method_wrappable :test_method }
    expect(FooBar.new.test_method).to be_kind_of Present
    destroy_class
  end

  it "wrapped method should return correct value when unwrapped" do
    build_class
    Object.module_eval { define_method :test_method do "something"; end }
    FooBar.module_eval { method_wrappable :test_method }
    expect(FooBar.new.test_method.unwrap).to eq "something"
    destroy_class
  end

  it "wrapped method should return same value as naked method" do
    build_class
    Object.module_eval { define_method :test_method do "something"; end }
    FooBar.module_eval { method_wrappable :test_method }
    foo_bar = FooBar.new
    expect(foo_bar.test_method.unwrap).to eq foo_bar.test_method_naked
    destroy_class
  end

  it "method_wrappable should work with methods that have arguments" do
    build_class
    Object.module_eval { define_method :test_method do |arg1, arg2| "#{arg1}, #{arg2}"; end }
    FooBar.module_eval { method_wrappable :test_method }
    expect(FooBar.new.test_method("hello", "world").unwrap).to eq "hello, world"
    destroy_class
  end

  it "method_wrappable should work with methods that have splat arguments" do
    build_class
    Object.module_eval { define_method :test_method do |*args| args.join(", "); end }
    FooBar.module_eval { method_wrappable :test_method }
    expect(FooBar.new.test_method("hello", "world").unwrap).to eq "hello, world"
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
