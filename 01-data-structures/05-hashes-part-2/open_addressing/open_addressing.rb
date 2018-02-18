require_relative 'node'

class OpenAddressing
  def initialize(size)
    @items = Array.new(size)
    @size = @items.length
    @pairs = 0
  end


def []=(key, value)
  i = index(key, @size)
  if @items[i] == nil
    @items[i] = Node.new(key, value)
    @pairs += 1
  else @items[i].key == key && @items[i].value != value
    j = next_open_index(i)
    if j == -1
      resize
    else
      @items[j] = Node.new(key, value)
      @pairs += 1
    end
  end
end

def [](key)
  (0...@items.length).each do |i|
    if @items[i] != nil
      if @items[i].key == key
        return @items[i].value
      end
    end
  end
end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size)
    key.sum % size
  end

  # Given an index, find the next open index in @items
  def next_open_index(index)
    (0...@size).each do |i|
      if @items[i] === nil
        return i
      end
    end
    return -1
  end


  # Simple method to return the number of items in the hash
  def size
    @items.length
  end

  # Resize the hash
  def resize
    @size = @size * 2
    new_hash = Array.new(@size)
    (0...@items.length).each do |i|
      if @items[i]
        new_hash[index(@items[i].key, @size)] = @items[i]
        @items[i] = nil
      end
    end
    @items = new_hash
  end

  def load_factor
    return @pairs.to_f / @size.to_f
  end

  def hash_print
    (0...@size).each do |i|
      if @items[i] != nil
        puts "index: #{i}  |  key: #{@items[i].key}  |  value: #{@items[i].value}"
      end
    end
    puts "load factor:#{load_factor}\n\n\n"
  end

end
