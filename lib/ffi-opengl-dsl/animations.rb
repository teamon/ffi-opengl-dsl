module OpenGL
  module Animations
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    class Animation    
      attr_accessor :app
  
      def initialize(param, opts, &block)
        @param = param
        @opts = opts
        @block = block
    
        init
      end
  
      protected
  
      def set_param(value)
        app.instance_variable_set("@#{@param}", @value)
      end
  
      def init; end
    end

    class BlockAnimation < Animation
      def call
        app.instance_exec &@block
      end
    end

    class LinearAnimation < Animation
      def init
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
