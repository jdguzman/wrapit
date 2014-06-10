# Wrapit

[![Code Climate](https://codeclimate.com/github/jdguzman/wrapit.png)](https://codeclimate.com/github/jdguzman/wrapit)
[![Build Status](https://travis-ci.org/jdguzman/wrapit.svg?branch=master)](https://travis-ci.org/jdguzman/wrapit)

Wrapit allows you to easily define attributes in a class that should be wrapped,
or wrap attributes that have already been defined.  The wrapping logic comes from
the [wrapped](https://github.com/mike-burns/wrapped) gem.

## Installation

Add this line to your application's Gemfile:

    gem 'wrapit'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wrapit

## Usage

So lets say we want to create some setters and getters for a class that come all
wrapped and ready to go.

    class Foo
      include Wrapit::AttrWrappable

      attr_wrappable :test_attr
    end

    foo = Foo.new

    foo.test_attr = "bar"
    foo.test_attr => #<Present:0x0000010ad6fc80 @value="bar">
    foo.test_attr.unwrap => "bar"

    foo.test_attr = nil
    foo.test_attr => #<Blank:0x0000010d3064f8>
    foo.test_attr.unwrap => IndexError: Blank has no value
    foo.test_attr.unwrap_or("bar") => "bar"

In addition to wrapping up the attribute readers, attr_wrappable creates *_naked* attribute writers:

    foo.test_attr_naked => nil
    foo.test_attr_naked = "bar"
    foo.test_attr_naked => "bar"

    # test_attr= is just an alias to test_attr_naked=
    foo.test_attr = "foo"
    foo.test_attr_naked = "foo"

Now lets say you have a method you have inherited from a superclass you want to wrap.

    class Foo
      def test_method
        "bar"
      end
    end

    class Bar < Foo
      include Wrapit::MethodWrappable

      method_wrappable :test_method
    end

    bar = Bar.new

    bar.test_method => #<Present:0x0000010ad6fc80 @value="bar">
    bar.test_method.unwrap => "bar"

And that's it!

## Limitations

At the moment method_wrappable is only usable on methods defined in a superclass and
that take no arguments. It also does't create the *_naked* variants of the wrapped
method.

## TODO

1. Add option to attr_wrappable to skip creating attribute writers.
2. Make method_wrappable work with methods that take arguments.
3. Look into method_wrappable working better in scenarios where we want to wrap a dynamic
method. ie. ActiveRecord attributes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
