# RubyIdenticon

[![Gem Version](https://badge.fury.io/rb/ruby_identicon.png)](http://badge.fury.io/rb/ruby_identicon)
[![Build Status](https://api.travis-ci.org/chrisbranson/ruby_identicon.png?branch=master)](http://travis-ci.org/chrisbranson/ruby_identicon)
[![Dependency Status](https://gemnasium.com/chrisbranson/ruby_identicon.png)](https://gemnasium.com/chrisbranson/ruby_identicon)
[![Coverage Status](https://coveralls.io/repos/chrisbranson/ruby_identicon/badge.png)](https://coveralls.io/r/chrisbranson/ruby_identicon)

![Example Identicon](https://dl.dropboxusercontent.com/u/176278/ruby_identicon.png)

A Ruby implementation of [go-identicon](https://github.com/dgryski/go-identicon) by Damian Gryski

RubyIdenticon creates an [identicon](https://en.wikipedia.org/wiki/Identicon), similar to those created by [Github](https://github.com/blog/1586-identicons).

A title and key are used by siphash to calculate a hash value that is then used to create a visual identicon representation. The identicon is made by creating a left hand side pixel representation of each bit in the hash value - this is then mirrored onto the right hand side to create an image that we see as a shape. The grid and square sizes can be varied to create identicons of differing size.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_identicon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_identicon

## Usage

Creating an identicon and saving to png
```ruby
RubyIdenticon.create_and_save("RubyIdenticon", "ruby_identicon.png")
```

Creating an identicon and returning a binary string
```ruby
blob = RubyIdenticon.create("RubyIdenticon")

# optional, save to a file
File.open("ruby_identicon.png", "wb") do |f| f.write(blob) end
```

Creating an identicon and returns in base64 format
```ruby
base64_identicon = RubyIdenticon.create_base64("RubyIdenticon")
```    
nb// to render this in html pass the base64 code into your view
```ruby  
raw "<img src='data:image/png;base64,#{base64_identicon}'>"
```

## Customising the identicon

The identicon can be customised by passing additional options

    background_color:  (Integer, default 0) the background color of the identicon in rgba notation (e.g. 0xffffffff for white)
    border_size:  (Integer, default 35) the size in pixels to leave as an empty border around the identicon image
    grid_size:    (Integer, default 7)  the number of rows and columns in the identicon, minimum 4, maximum 9
    square_size:  (Integer, default 50) the size in pixels of each square that makes up the identicon
    key:          (String) a 16 byte key used by siphash when calculating the hash value (see note below)

    Varying the key ensures uniqueness of an identicon for a given title, it is assumed desirable for different applications
    to use a different key.

Example
```ruby
blob = RubyIdenticon.create("identicons are great!", grid_size: 5, square_size: 70, background_color: 0xf0f0f0ff, key: "1234567890123456")
File.open("tmp/test_identicon.png", "wb") do |f| f.write(blob) end
 ```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
