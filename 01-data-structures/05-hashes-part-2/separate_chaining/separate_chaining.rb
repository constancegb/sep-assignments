require_relative 'linked_list'
require_relative 'node'

class SeparateChaining
  attr_reader :max_load_factor
  attr_accessor :pairs

  def initialize(size)
    @max_load_factor = 0.7
    @pairs = 0
    @items = Array.new(size)
    @size = size
  end

  def []=(key, value)
    i = index(key, @size)
    # create new linked list at index
    if @items[i] == nil
      @items[i] = LinkedList.new
      @items[i].add_to_front(Node.new(key, value))
      @pairs += 1
    # existing linked list at the index
    else
      temp = @items[i].head
      # cycle through the linked list
      until temp == nil || temp.key == key
        temp = temp.next
      end
      if temp == nil
        @items[i].add_to_front(Node.new(key, value))
        @pairs += 1
      elsif temp.key == key && temp.value != value
        temp.value = value
      end
    end
    if load_factor > @max_load_factor
      resize
    end
  end

  def [](key)
    i = index(key, size)
    if @items[i] != nil
      temp = @items[i].head
      until temp == nil || temp.key == key
        temp = temp.next
      end
      return temp.value
    end
  end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size)
    return key.sum % size
  end

  # Calculate the current load factor
  def load_factor
    return @pairs.to_f / size.to_f
  end

  # Simple method to return the number of buckets in the hash
  def size
    @items.length
  end

  # Resize the hash
  def resize
    new_hash = Array.new(@items.length * 2)
    (0...@items.length).each do |i|
      if @items[i] != nil
        temp = @items[i].head
        until temp == nil
          j = index(temp.key, new_hash.length)
          new_hash[j] = LinkedList.new
          new_hash[j].add_to_front(temp)
          temp = temp.next
        end
        @items[i] = nil
      end
    end
    @items = new_hash
  end

  def hash_print
    (0...@items.length).each do |i|
      if @items[i] != nil
        puts "index #{i}:"
        puts @items[i].print
      end
    end
    puts "load factor: #{load_factor()}\n\n\n"
  end

end
