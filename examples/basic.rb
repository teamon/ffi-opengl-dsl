require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

# Basic example
# It should show blue triangle on white background

class Basic < OpenGL::App
  setup2D! # Needed for 2D setup
  
  def display
    clear "#fff" # Clear background with white
    
    color "#00fa" # You can use RGBA

    translate 100, 100 # Move to (100, 100)
    rotate 30 # Rotate 30 degrees
    triangle [0,0], [100,100], [0,100] # draw triangle between (0,0), (100, 100) and (0, 100) points
  end
  
end

app = Basic.new(400, 300, __FILE__) # create new application with 400x300 window 
app.start # start application
