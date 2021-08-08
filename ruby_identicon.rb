#!/usr/bin/env ruby

require_relative "lib/ruby_identicon"

abort "Please run with a filename as an argument" unless ARGV[0]
filename = ARGV[0].clone
ARGV.clear

print "Reading standard input to generate identicon...\n"

identstring = gets

blob = RubyIdenticon.create(identstring, grid_size: 5, square_size: 70, background_color: 0xf0f0f0ff, key: "1234567890123456")
File.open(filename, "wb") { |f| f.write(blob) }
