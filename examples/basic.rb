require_relative "../lib/ffi-opengl-dsl"

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
    clear "#fff"
    
    color "#00f3"
    
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
    
    color "#f005"
    
    matrix do
      translate @offset, 100
      triangle [0,0], [100,100], [0,100]
    end
    
  end
  
end

app = Test.new(400, 300)
app.start