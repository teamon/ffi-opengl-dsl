module OpenGL
  module Animations
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    # Base class for all animations
    class Animation    
      attr_accessor :app
  
      # Constructor
      #
      # @param [Symbol] param instance variable name to be changed by animation
      # @param [Hash] opts animation options
      def initialize(param, opts, &block)
        @param = param
        @opts = opts
        @block = block
      end
  
      protected
  
      def set_param(value)
        app.instance_variable_set("@#{@param}", @value)
      end
  
    end

    # Executes provided block 
    # It`s up to use to do sleep(..) inside block
    class BlockAnimation < Animation
      def call
        app.instance_exec &@block
      end
    end

    # Increments value same amount each step, if value passes the range it gets it`s first value
    class LinearAnimation < Animation
      # Constructor overload
      #
      # @param [Symbol] param instance variable name to be changed by animation
      # @param [Hash] opts animation options
      # @option opts [Range] :in Range
      # @option opts [Fixnum, Float] :step Amound added to value each step
      # @option opts [Fixnum, Float] :sleep Sleep time between steps
      def initialize(param, opts, &block)
        @param = param
        @opts = opts
        @block = block
        @value = @opts[:in].first
      end
  
      def call
        @value += @opts[:step]
        @value = @opts[:in].first unless @opts[:in].include?(@value)
        sleep(@opts[:sleep] || 0.01)
    
        set_param @value
      end
    end
    
    
    module InstanceMethods
      def start_animations!
        @animations = []        
        self.class.animations.each do |a|
          animation = a.dup
          animation.app = self
          @animations << animation
          
          Thread.new(animation) do |anim|
            loop { anim.call }
          end
        end
      end
    end
    
    module ClassMethods
      def animate(param = "", opts = {}, &block)
        if block_given?
          animations << BlockAnimation.new(param, opts, &block)
        else
          animations << opts[:with].new(param, opts)
        end
      end
      
      def animations
        @animations ||= []
      end
    end
    
    
  end
end
