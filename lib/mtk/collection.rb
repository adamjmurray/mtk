module MTK

  # Given a method #elements, which returns an Array of elements in the collection,
  # including this module will make the class Enumerable and provide various methods you'd expect from an Array.
  module Collection
    include Enumerable

    # The array of elements in this collection
    def to_a
      Array.new(elements)
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

  end

end