# frozen_string_literal: true

#--
# Copyright (c) 2013 Chris Branson
#
# Based on the go-identicon code at https://github.com/dgryski/go-identicon
# go-identicon Copyright (c) 2013, Damian Gryski <damian@gryski.com>
# Credit to Damian Gryski for the original concept.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'ruby_identicon/version'
require 'chunky_png'
require 'siphash'
require 'base64'

#
# A Ruby implementation of go-identicon
#
# RubyIdenticon creates an Identicon, similar to those created by Github.
#
# A title and key are used by siphash to calculate a hash value that is
# then used to create a visual identicon representation.
#
# The identicon is made by creating a left hand side pixel representation
# of each bit in the hash value - this is then mirrored onto the right
# hand side to create an image that we see as a shape.
#
# The grid and square sizes can be varied to create identicons of
# differing size.
#
module RubyIdenticon
  # the default options used when creating identicons
  #
  # background_color: (Integer, default 0) the background color of the identicon in rgba notation (e.g. xffffffff for white)
  # border_size:      (Integer, default 35) the size in pixels to leave as an empty border around the identicon image
  # grid_size:        (Integer, default 7)  the number of rows and columns in the identicon, minimum 4, maximum 9
  # square_size:      (Integer, default 50) the size in pixels of each square that makes up the identicon
  # key:              (String) a 16 byte key used by siphash when calculating the hash value (see note below)
  #
  # varying the key ensures uniqueness of an identicon for a given title, it is assumed desirable for different applications
  # to use a different key.
  #
  DEFAULT_OPTIONS = {
    border_size: 35,
    square_size: 50,
    grid_size: 7,
    key: "\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF"
  }.freeze

  # create an identicon png and save it to the given filename
  #
  # Example:
  #   >> RubyIdenticon.create_and_save('identicons are great!', 'test_identicon.png')
  #   => result (Boolean)
  #
  # @param title [string] the string value to be represented as an identicon
  # @param filename [string] the full path and filename to save the identicon png to
  # @param options [hash] additional options for the identicon
  #
  def self.create_and_save(title, filename, options = {})
    raise 'filename cannot be nil' if filename.nil?

    blob = create(title, options)
    return false if blob.nil?

    File.open(filename, 'wb') { |f| f.write(blob) }
  end

  # create an identicon png and return it as a binary string
  #
  # Example:
  #   >> RubyIdenticon.create('identicons are great!')
  #   => binary blob (String)
  #
  # @param title [string] the string value to be represented as an identicon
  # @param options [hash] additional options for the identicon
  #
  def self.create(title, options = {})
    options = DEFAULT_OPTIONS.merge(options)

    raise 'title cannot be nil' if title.nil?
    raise 'key is nil or less than 16 bytes' if options[:key].nil? || options[:key].length < 16
    raise 'grid_size must be between 4 and 9' if options[:grid_size] < 4 || options[:grid_size] > 9
    raise 'invalid border size' if options[:border_size] < 0
    raise 'invalid square size' if options[:square_size] < 0

    hash = SipHash.digest(options[:key], title)

    png = ChunkyPNG::Image.new((options[:border_size] * 2) + (options[:square_size] * options[:grid_size]),
                               (options[:border_size] * 2) + (options[:square_size] * options[:grid_size]), ChunkyPNG::Color.from_hex('#FF9800'))

    # set the foreground color by using the first three bytes of the hash value
    color = ChunkyPNG::Color.from_hex('#E65100')

    # remove the first three bytes that were used for the foreground color
    hash >>= 24

    sqx = sqy = 0
    (options[:grid_size] * ((options[:grid_size] + 1) / 2)).times do
      if hash & 1 == 1
        x = options[:border_size] + (sqx * options[:square_size])
        y = options[:border_size] + (sqy * options[:square_size])

        # left hand side
        png.rect(x, y, x + options[:square_size] - 1, y + options[:square_size] - 1, color, color)

        # mirror right hand side
        x = options[:border_size] + ((options[:grid_size] - 1 - sqx) * options[:square_size])
        png.rect(x, y, x + options[:square_size] - 1, y + options[:square_size] - 1, color, color)
      end

      hash >>= 1
      sqy += 1
      if sqy == options[:grid_size]
        sqy = 0
        sqx += 1
      end
    end

    png.to_blob color_mode: ChunkyPNG::COLOR_INDEXED
  end

  def self.create_base64(title, options = {})
    Base64.encode64(create(title, options)).force_encoding('UTF-8')
  end
end
