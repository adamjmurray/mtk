module MTK

  # Given a method #elements, which returns an Array of elements in the collection,
  # including this module will make the class Enumerable and provide various methods you'd expect from an Array.
  module Collection
    include Enumerable

    # A mutable array of elements in this collection
    def to_a
      Array.new(elements) # we construct a new array since some including classes make elements be immutable
    end

    # The number of elements in this collection
    def size
      elements.size
    end
    alias length size

    # The each iterator for providing Enumerable functionality
    def each &block
      elements.each &block
    end

    # The first element
    def first
      elements.first
    end

    # The last element
    def last
      elements.last
    end

    # The element with the given index
    def [](index)
      elements[index]
    end

    def repeat(times=2)
      full_repetitions, fractional_repetitions = times.floor, times%1  # split into int and fractional part
      base = elements * full_repetitions
      base += elements[0...elements.size*fractional_repetitions]
      self.class.from_a(base)
    end

    def permute
      self.class.from_a(elements.shuffle)
    end
    alias shuffle permute

    def rotate(offset=1)
      self.class.from_a(elements.rotate offset)
    end

    def concat(other_collection)
      self.class.from_a(elements + other_collection.elements)
    end

    def reverse
      self.class.from_a(to_a.reverse)
    end
    alias retrograde reverse

    def ==(other)
      if other.respond_to? :elements
        elements == other.elements
      else
        elements == other
      end
    end

  end

end

if not Array.instance_methods.include? :rotate
  # Array#rotate is only available in Ruby 1.9, so we may have to implement it
  class Array
    def rotate(offset=1)
      return self if empty?
      offset %= length
      self[offset..-1]+self[0...offset]
    end
  end
end