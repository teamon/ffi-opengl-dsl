module OpenGL
  module DSL
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    module InstanceMethods
      include FFI, GL, GLU, GLUT
      include Helpers

      def initialize(width, height, name = "Ruby FFI OpenGL")
        @window = {:width => width, :height => height, :name => name}
        glut_init
        init
      end

      def start
        glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
        glutInitWindowSize(@window[:width], @window[:height])
        glutCreateWindow(@window[:name])
        glutDisplayFunc(method(:do_display).to_proc)
        glutIdleFunc(method(:do_idle).to_proc)
        glutReshapeFunc(method(:do_reshape).to_proc)
        start_animations!
        glutMainLoop
      end

      def init; end
      def idle; end
      def reshape(width, height); end
      def display; end

      protected

      def do_display
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
                
        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
        
        matrix do
          display
        end
        
        glutSwapBuffers        
      end

      def do_reshape(width, height)
        if self.class.use2D
          glViewport(0, 0, width, height)

        	glMatrixMode(GL_PROJECTION)
        	glLoadIdentity
        	gluOrtho2D(0, width, 0, height)
        	glMatrixMode(GL_MODELVIEW)
      	end
      	
      	reshape(width, height)
      end
      
      def do_idle
        do_display
      end

      def glut_init
        glutInit(MemoryPointer.new(:int, 1).put_int(0, 0), 
                 MemoryPointer.new(:pointer, 1).put_pointer(0, nil))
      end
          
      def start_animations!
        self.class.animations.each do |animation|
          animation.app = self
          
          Thread.new(animation) do |anim|
            loop { anim.call }
          end
        end
      end
      
    
    end # InstanceMethods
    
    module ClassMethods
      attr_accessor :use2D
      
      def setup2D!
        self.use2D = true
      end
      
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
    
    end # ClassMethods
    
  end # DSL
end # OpenGL

