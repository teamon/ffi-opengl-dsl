require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

class Colors < OpenGL::App
  setup2D!
  
  def display
    clear "#fff" # Clear background with white
    
    translate 0, 20
    
    # short notation
    color "#f00"
    translate 60, 0
    square
    
    # With alpha
    color "#f00a"
    translate 60, 0
    square
    
    # Long notation
    color "#0000ff"
    translate 60, 0
    square
    
    # With alpha
    color "#0000ffaa"
    translate 60, 0
    square
    
    # Some fun
    
    translate -180, 100
    color "#00fa"
    square
    
    translate 10, 10
    color "#f00a"
    square
    
    translate 10, 10
    color "#0f0a"
    square
  end
  
  # Handy helper method
  def square
    quad [0,0], [40, 0], [40, 40], [0, 40]
  end
    
end

app = Colors.new(400, 300, __FILE__) # create new application with 400x300 window 
app.start # start application
