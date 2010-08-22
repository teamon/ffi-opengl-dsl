require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

class Anim < OpenGL::App
  setup2D!
  
  # Change @offset instance variable from 0 to 250 by 2 each step
  animate :offset, :with => LinearAnimation, :in => (50..250), :step => 2
  
  # You can provide custom animation. 
  # Remeber to intialize your instance variable
  animate do
    if @angle < 360
      @angle += 1
    else
      @angle = 0
    end
    sleep(0.01)
  end
  
  def initialize(width, height, name)
    super(width, height, name)
    
    @angle = 0 # Initialize for animation
  end
  
  def display
    clear "#000" # black background
            
    matrix do
      color "#f009"
      translate 100, 100
      rotate @angle
      
      # More low-level way to draw quad
      quads do
        vertex -50, -50
        vertex -50,  50    
        vertex  50,  50
        vertex  50, -50
      end
    end
    
    matrix do
      color "#00f9"
      translate @offset, @offset
      
      quads do
        vertex -50, -50
        vertex -50,  50    
        vertex  50,  50
        vertex  50, -50
      end
        
    end
  end
  
end
    
app = Anim.new(400, 300, __FILE__) # create new application with 400x300 window 
app.start # start application
