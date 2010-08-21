require "ffi-opengl"

module OpenGL
  module DSL
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    module InstanceMethods
      include FFI, GL, GLU, GLUT

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
      
      def matrix
        glPushMatrix
        yield
        glPopMatrix
      end
      
      def quads(&block)
        with(GL_QUADS, &block)
      end
      
      def quad(*args)
        quads do
          args.each {|v| vertex *v }
        end
      end
      
      def triangles(&block)
        with(GL_TRIANGLES, &block)
      end
      
      def triangle(*args)
        triangles do
          args.each {|v| vertex *v }
        end
      end
      
      def with(what)
        glBegin(what)
        yield
        glEnd
      end
      
      def vertex(x, y, z=nil)
        if z
          glVertex3f(x, y, z)
        else
          glVertex2f(x, y)
        end
      end
      
      def translate(x, y, z = 0.0)
        glTranslatef(x.to_f, y.to_f, z.to_f)
      end
      
      def rotate(angle, x = nil, y = nil,  z = nil)
        z ||= 1.0 if self.class.use2D
        glRotatef(angle.to_f, x || 0.0, y || 0.0, z)
      end
      
      def color(name)
        if name.is_a?(String)
          if name =~ /^#[0-9a-fA-F]{3}$/
            r = (name[1]*2).to_i(16)
            g = (name[2]*2).to_i(16)
            b = (name[3]*2).to_i(16)
          elsif name =~ /^#[0-9a-fA-F]{6}$/
            r = name[1..2].to_i(16)
            g = name[3..4].to_i(16)
            b = name[5..6].to_i(16)
          else
            raise ArgumentError.new("Color string is invalid")
          end
          
   
          
          glColor3f(r/255.0, g/255.0, b/255.0)
        else
          raise ArgumentError.new("Color is invalid")
        end
      end
      
      def start_animations!
        self.class.animations.each do |animation|
          animation.app = self
          
          Thread.new(animation) do |anim|
            loop { anim.call }
          end
        end
      end
      
      
        
    end
    
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
        

        

  end
end


class Test
  include OpenGL::DSL
  
  animate :offset, :with => LinearAnimation, :in => (0..250), :step => 2
  
  animate do
    if @angle < 360
      @angle += 1
    else
      @angle = 0
    end
    sleep(0.01)
  end
  
  def init
    @angle = 0
  end
  
  setup2D!
  
  def display
    color "#00f"
    
    matrix do
      translate 100, 100
      rotate @angle
      
      quads do
        vertex -50, -50
        vertex -50,  50    
        vertex  50,  50
        vertex  50, -50
      end
    end
    
    color "#f00"
    
    matrix do
      translate @offset, 100
      # triangles do
      #   vertex 0, 0
      #   vertex 100, 100
      #   vertex 0, 100
      # end
      
      triangle [0,0], [100,100], [0,100]
    end
    
  end
  
end

app = Test.new(400, 300)
app.start

