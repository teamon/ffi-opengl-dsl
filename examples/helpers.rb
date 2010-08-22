require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

# Helpers example

class Hlprs < OpenGL::App
  setup2D! # Needed for 2D setup
  
    
  def display
    clear "#fff" # Clear background with white
    
    color "#00fa" # You can use RGBA

    translate 100, 100 do
      translate 50, 0
      rect 200, 100

      translate 150, 0
      circle 50
    end

    translate 100, 200 do
      ring 40, 50
      translate 100, 0
      
      color "#00f4"
      ring 30, 50
      color "#00fa"
      arc 30, 50, 15, 90
      
      translate 100, 0
      square 100
    end   
    
  end
  
end

app = Hlprs.new(400, 300, __FILE__) # create new application with 400x300 window 
app.start # start application
