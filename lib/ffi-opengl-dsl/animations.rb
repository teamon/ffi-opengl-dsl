module OpenGL
  module DSL
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
  end
end
