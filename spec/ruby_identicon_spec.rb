require 'rspec'
require 'ruby_identicon'

describe RubyIdenticon do
  it "creates a binary string image blob" do
    expect(RubyIdenticon.create("RubyIdenticon")).to be_a_kind_of(String)  
  end

  it "does not create a binary string image blob with an invalid title" do
    lambda { RubyIdenticon.create(nil) }.should raise_exception("title cannot be nil")
  end

  it "does not create a binary string image blob with an invalid key" do
    lambda { RubyIdenticon.create("identicons are great!", key: "\x00\x11\x22\x33\x44") }.should raise_exception("key is nil or less than 16 bytes")
  end

  it "does not create a binary string image blob with an invalid grid size" do
    lambda { RubyIdenticon.create("RubyIdenticon", grid_size: 2) }.should raise_exception("grid_size must be between 4 and 9")
    lambda { RubyIdenticon.create("RubyIdenticon", grid_size: 20) }.should raise_exception("grid_size must be between 4 and 9")
  end

  it "does not create a binary string image blob with an invalid square_size size" do
    lambda { RubyIdenticon.create("RubyIdenticon", square_size: -2) }.should raise_exception("invalid square size")
  end

  it "does not create a binary string image blob with an invalid border_size size" do
    lambda { RubyIdenticon.create("RubyIdenticon", border_size: -2) }.should raise_exception("invalid border size")
  end



  it "creates a png image file" do
    blob = RubyIdenticon.create("RubyIdenticon")
    result = File.open("tmp/ruby_identicon.png", "wb") do |f| f.write(blob) end
    expect(result).to be_true
  end

  it "creates a png image file of grid size 5, square size 70 and grey background" do
    blob = RubyIdenticon.create("RubyIdenticon", grid_size: 5, square_size: 70, background_color: 0xf0f0f0ff, key: "1234567890123456")
    result = File.open("tmp/ruby_identicon_gs5_white.png", "wb") do |f| f.write(blob) end
    expect(result).to be_true
  end

  it "creates 10 png image files" do
    10.times do |count|
      blob = RubyIdenticon.create("RubyIdenticon_#{count}")
      result = File.open("tmp/ruby_identicon_#{count}.png", "wb") do |f| f.write(blob) end
      expect(result).to be_true
    end
  end



  it "creates a png image file via create_and_save" do
    result = RubyIdenticon.create_and_save("RubyIdenticon is fun", "tmp/test_identicon.png")
    expect(result).to be_true
  end

  it "does not create a png image file via create_and_save with an invalid filename" do
    lambda { RubyIdenticon.create_and_save("RubyIdenticon is fun", nil) }.should raise_exception("filename cannot be nil")
  end

  it "does not create a png image file via create_and_save with an invalid title" do
    lambda { RubyIdenticon.create_and_save(nil, "tmp/test_identicon.png") }.should raise_exception("title cannot be nil")
  end
end
