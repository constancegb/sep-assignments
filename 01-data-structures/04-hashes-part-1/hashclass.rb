class HashClass

  require_relative 'hash_item'

  def initialize(size)
    @items = Array.new(size)
    @size = size
  end

  def []=(key, value)
    i = index(key, @size)
   # New hash element
   if @items[i].nil?
     @items[i] = HashItem.new(key, value)
   # Collision
   elsif @items[i].key != key
     # Resize hash until no more collision
     while @items[i].key != nil && @items[i].key != key
       resize
       j = index(key, @size)
       break if @items[j] == nil || @items[j].key == key
     end
     self[key] = value
   elsif @items[i].key == key && @items[i].value != value
     resize
     j = index(key, @size)
     @items[j].value = value
     # puts @items[j].key
   end
  end

  def [](key)
    item = @items[index(key, @size)]
    item.nil? ? nil : item.value
  end

  def resize
    @size = @size * 2
    new_hash = Array.new(@size)
    @items.each do |item|
      if item != nil
        new_hash[index(item.key, @size)] = item
      end
    end
    @items = new_hash
  end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size)
    key.sum % size
  end

  # Simple method to return the number of items in the hash
  def size
    @size
  end

end
