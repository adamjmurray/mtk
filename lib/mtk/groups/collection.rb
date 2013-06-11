module MTK
  module Groups

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

       def empty?
         elements.nil? or elements.size == 0
       end

       # The each iterator for providing Enumerable functionality
       def each &block
         elements.each(&block)
       end

       # the original Enumerable#map implementation, which returns an Array
       alias enumerable_map map

       # the overriden #map implementation, which returns an object of the same type
       def map &block
         clone_with enumerable_map(&block)
       end

       # The first element
       def first(n=nil)
         n ? elements.first(n) : elements.first
       end

       # The last element
       def last(n=nil)
         n ? elements.last(n) : elements.last
       end

       # The element with the given index
       def [](index)
         elements[index]
       end

       def repeat(times=2)
         full_repetitions, fractional_repetitions = times.floor, times%1  # split into int and fractional part
         repeated = elements * full_repetitions
         repeated += elements[0...elements.size*fractional_repetitions]
         clone_with repeated
       end

       def permute
         clone_with elements.shuffle
       end
       alias shuffle permute

       def rotate(offset=1)
         clone_with elements.rotate(offset)
       end

       def concat(other)
         other_elements = (other.respond_to? :elements) ? other.elements : other
         clone_with(elements + other_elements)
       end

       def reverse
         clone_with elements.reverse
       end
       alias retrograde reverse


       # Partition the collection into an Array of sub-collections.
       #
       # With a Numeric argument: partition the elements into collections of the given size (plus whatever's left over).
       #
       # With an Array argument: partition the elements into collections of the given sizes.
       #
       # Otherwise if a block is given: partition the elements into collections with the same block return value.
       #
       def partition(arg=nil, &block)
         partitions = nil
         case arg
           when Numeric
             partitions = self.each_slice(arg)

           when Enumerable
             partitions = []
             items, sizes = self.to_enum, arg.to_enum
             group = []
             size = sizes.next
             loop do
               item = items.next
               if group.size < size
                 group << item
               else
                 partitions << group
                 group = []
                 size = sizes.next
                 group << item
               end
             end
             partitions << group unless group.empty?

           else
             if block
               group = Hash.new{|h,k| h[k] = [] }
               if block.arity == 2
                 self.each_with_index{|item,index| group[block[item,index]] << item }
               else
                 self.each{|item| group[block[item]] << item }
               end
               partitions = group.values
             end
         end

         if partitions
           partitions.map{|p| self.class.from_a(p) }
         else
           self
         end
       end

       def ==(other)
         if other.respond_to? :elements
           if other.respond_to? :options
             elements == other.elements and @options == other.options
           else
             elements == other.elements
           end
         else
           elements == other
         end
       end

       # Create a copy of the collection.
       # In order to use this method, the including class must implement .from_a()
       def clone
         clone_with to_a
       end

       #################################
       private

       # "clones" the object with the given elements, attempting to maintain any @options
       # This is designed to work with 2 argument constructors: def initialize(elements, options=default)
       def clone_with elements
         from_a = self.class.method(:from_a)
         if @options and from_a.arity == -2
           from_a[elements, @options]
         else
           from_a[elements]
         end
       end

     end


     ######################################################################
     # MTK::Groups

     def to_pitch_classes(*anything)
       anything = anything.first if anything.length == 1
       if anything.respond_to? :to_pitch_classes
         anything.to_pitch_classes
       else
         case anything
           when ::Enumerable then anything.map{|item| MTK::PitchClass(item) }
           else [MTK::PitchClass(anything)]
         end
       end
     end
     module_function :to_pitch_classes


     def to_pitches(*anything)
       anything = anything.first if anything.length == 1
       if anything.respond_to? :to_pitches
         anything.to_pitches
       else
         case anything
           when ::Enumerable then anything.map{|item| MTK::Pitch(item) }
           else [MTK::Pitch(anything)]
         end
       end
     end
     module_function :to_pitches

  end
end
