module OpenGL
  class App
    include FFI, GL, GLU, GLUT
      
    include OpenGL::Helpers
    include OpenGL::Animations
    
    def initialize(width, height, name = "Ruby FFI OpenGL")
      @window = {:width => width, :height => height, :name => name}
      glut_init
    end
    
    def start
      glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
      glutInitWindowSize(@window[:width], @window[:height])
      glutCreateWindow(@window[:name])
      glutDisplayFunc(method(:do_display).to_proc)
      glutIdleFunc(method(:idle).to_proc)
      glutReshapeFunc(method(:reshape).to_proc)
      start_animations!
      glutMainLoop
    end
    
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
    
    def reshape(width, height)
      if OpenGL::App.use2D
        glViewport(0, 0, width, height)
    
      	glMatrixMode(GL_PROJECTION)
      	glLoadIdentity
      	gluOrtho2D(0, width, 0, height)
      	glMatrixMode(GL_MODELVIEW)
    	end
    end
    
    def idle
      do_display
    end
    
    def glut_init
      glutInit(MemoryPointer.new(:int, 1).put_int(0, 0), 
               MemoryPointer.new(:pointer, 1).put_pointer(0, nil))
    end
          
    
    class << self
      attr_accessor :use2D
      
      def setup2D!
        OpenGL::App.use2D = true
      end
  
    end
    
  end # App
end # OpenGL

