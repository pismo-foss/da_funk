# DaFunk, happiness modularity

DaFunk is a Embedded System Framework optimized for programmer happiness and sustainable productivity. It encourages modulatiry by adapter pattern an beautiful code by favoring convention over configuration.

## What do I have here?

This repository contains a set of files and folder that compose the
**DaFunk API**. The structure goes as follows:

- The `guides` directory, which contains a group of files that are intended to instruct how to use our framework.
- An `imgs` directory, containing a picture that references the creative origins of this project.
- A `lib` directory, which holds the main source code of our Framework API.
- An `out`directory, which has a previous generated binary of this project. All builds target this directory.
- A `test` directory with example test cases. Tests are divided by _integration_ tests and _unit_ tests.

## How do I use DaFunk?

### Embedded Projects

DaFunk is a gem to be used in MRuby environment, to provide the environment we created a CLI that is able to create, compile, run and test DaFunk Apps. You can check [here](http://github.com/da-funk/funky-cli)

Project creation flow in Ruby environment:

```
funky-cli new project
cd project
bundle install
bundle exec rake test:unit
```

### CRuby Projects

For more advanced users only wanting to use the `iso8583` module, here's how you require it:

```ruby
require 'da_funk/iso8583'
```

## I would like to contribute

Please follow the instructions:

1. Fork it under your github account!
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Added some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request!

## License

```
The MIT License (MIT)

Copyright (c) 2016 CloudWalk, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
### 
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

![DaFunk](https://raw.githubusercontent.com/cloudwalkio/da_funk/master/imgs/daft-punk-da-funk.jpg)
