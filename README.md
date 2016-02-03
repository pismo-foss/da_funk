# DaFunk, a.k.a. CloudWalk Framework API

Our goal at [CloudWalk][1] is to provide you with the
necessary tools to build Point Of Sales (POS) applications
in an easy and innovative way. To do so, we've developed
a setup for MRuby programs that allows you to build and
ship modern day applications to all of your terminals
instantaneously. For that purpose, you will need to start
using the API that is provided by this repository.

## Index

- [Index](#index)
- [What do I have here?](#what-do-i-have-here)
- [How do I use this?](#how-do-i-use-this)
- [Adding support to other platforms](#adding-support-to-other-platforms)
- [I would like to contribute](#i-would-like-to-contribute)

## What do I have here?

This repository contains a set of files and folder that compose the
**CloudWalk Framework API**. The structure goes as follows:

- The `guides` directory, which contains a group of files that are intended to instruct how to use our framework.
- An `imgs` directory, containing a picture that references the creative origins of this project.
- A `lib` directory, which holds the main source code of our Framework API.
- An `out`directory, which has a previous generated binary of this project. All builds target this directory.
- A `test` directory with example test cases. Tests are divided by _integration_ tests and _unit_ tests.
- A `utils` folder that contains some scripts which are useful for us to perform tests or interact with the command line environment.

## How do I use this?

We strongly recommend using our framework API from our [application skeleton][3],
it has all the minimal files and the structure needed to build your first application.

Essentially add to your `Gemfile`:

```ruby
gem 'da_funk', :git => 'https://github.com/cloudwalkio/da_funk.git'
```

Then require `da_funk` in your application file!

```ruby
require 'da_funk'
```

For more advanced users only wanting to use the `iso8583` module, here's how you require it:

```ruby
require 'da_funk/iso8583'
```

A full tutorial on how to develop your first CloudWalk app
can be found here: <https://docs.cloudwalk.io/en/cli>,
or checkout this project's source code!

## Adding support to other platforms

At CloudWalk we develop our framework targeting several POS terminal brands,
physical devices and even virtual devices (such as our web emulator).
To deal with the platform differences, we've created an abstraction layer
in da_funk that helps us modify our framework's behavior for our targets,
but ensuring the changes needed are minimal and separated from the
framework's source code. As an example, we offer our project:
[around_the_world][4], it is the recipe to have MRuby working on
non embedded platforms and with full compliance with DaFunk API.

The first step is to add `da_funk` as a submodule in your project, let's say you'll be hosting it on a git server,
proceed with:

    git submodule add git@github.com:cloudwalkio/da_funk.git path/to/lib/da_funk

Then, in your application, before starting anything, define your
platform interface. The most important feature it needs to have is
a `setup` method, which will be called to configure and initialize
everything before the actual execution.

```ruby
class PlatformInterface
  def self.setup
    # Configuration and initialization before apps execution
  end
end
```

Then you'll need to define your custom classes, but following the structure
present in our [device][5] source code. These classes can be in the same file
as the one that has the setup method, here is an example:

```ruby
class PlatformInterface
  Network = ::Network # Implemented on C
  IO      = ::IO # Implemeted on C

  class Display
    def self.clear
      ::IO.display_clear
    end

    def self.print_line(buf, row, column)
      # <class created on C or PlatformInterface>._print_line(buf, row, column)
      PlatformInterface._print_line(buf, row, column)
    end
  end
end
```

Some important notes regarding your platform interface:

- Be careful with the instance object variable, leave that for DaFunk.
- Put preference into using class methods instead of making calls as the interface.
- We might revise this in the future, but for now: any method defined for
  platform-specific usages has to be defined with a name that starts with `_`,
  for example: `_myMethod`.

Once you're comfortable with your platform class,
we need to set it up as the adapter to use by altering DaFunk's device class:

```ruby
class Device # Class from DaFunk
  self.adapter = PlatformInterface
end
```

The adapter pattern is based is a well studied software design pattern,
we recommend you to read the [Wiki article][7], it's an interesting bit
of information that is rooted deep in our solutions.

Finally build it with `rake` or in a more specific manner, with: `mrbc -o platform.mrb </path/to/mrblib/**/*/.rb>`

In [this link][6] there is an example of the whole process. Enjoy the reading! :bowtie:

## I would like to contribute

So, you want to propose changes to our skeleton??!! Thank you sir! We appreciate it :bowtie:

Please follow the instructions:

1. Fork it under your github account!
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Added some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request!

## License

```
The MIT License (MIT)

Copyright (c) 2015 CloudWalk, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

[1]: https://www.cloudwalk.io
[2]: https://www.cloudwalk.io/cli/
[3]: https://github.com/cloudwalkio/cloudwalk-skeleton
[4]: https://github.com/cloudwalkio/around_the_world
[5]: https://github.com/cloudwalkio/da_funk/tree/master/lib/device
[6]: https://github.com/cloudwalkio/mruby-cloudwalk-platform
[7]: https://en.wikipedia.org/wiki/Adapter_pattern

![DaFunk](https://raw.githubusercontent.com/cloudwalkio/da_funk/master/imgs/daft-punk-da-funk.jpg)
