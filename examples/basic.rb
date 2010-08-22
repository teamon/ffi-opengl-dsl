require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

# Basic example
# It should show blue triangle and red rectangle on white background

class Basic < OpenGL::App
  setup2D!                # Needed for 2D setup
  
  def display
    clear "#fff"          # Clear background with white
    
    color "#00f5"         # You can use RGBA

    translate 100, 50     # Move 100 up and 50 left
    rotate 30             # Rotate 30 degrees
    triangle [0,0], [100,100], [0,100] # draw triangle between (0,0), (100, 100) and (0, 100) points
    
    color "#f005"
    rotate 60
    rect 70, 100
  end
  
end

app = Basic.new(300, 200, __FILE__) # create new application with 300x200 window 
app.start # start application
