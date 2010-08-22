require_relative "../lib/ffi-opengl-dsl"

class Foo
  include OpenGL::Helpers
  include OpenGL::Animations
  
  animate :angle, :with => LinearAnimation, :in => (0..250), :step => 2
  
  def display
    matrix do
      color "#f90"
      translate 100, 100
      rotate @angle
      triangle [0,0], [60,100], [0,100]
    end
  end
end

class Test < OpenGL::App
  
  animate :offset, :with => LinearAnimation, :in => (0..250), :step => 2
  
  animate do
    if @angle < 360
      @angle += 1
    else
      @angle = 0
    end
    sleep(0.01)
  end
  
  def initialize(width, height, name = "Ruby FFI OpenGL")
    super(width, height, name)
    
    @angle = 0
    
    @foo = Foo.new
  end
  
  setup2D!
  
  def display
    clear "#f0f"
    
    color "#000"

    
    
    
    color "#f0f"
        
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
    
    color "#ff05"
    
    matrix do
      translate @offset, 100
      triangle [0,0], [100,100], [0,100]
    end
    
    color "#fffd"
    
    matrix do
      translate 200, 200
      rotate 5*@angle
      quad [-25,-25], [-25, 25], [25, 25], [25, -25]
    end
    
    @foo.display
    
  end
  
end

app = Test.new(400, 300)
app.start