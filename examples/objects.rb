require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "ffi-opengl-dsl")

class Box
  include OpenGL::Helpers
  include OpenGL::Animations # If you want animation (and you probably do)

  animate :angle, :with => LinearAnimation, :in => (0..360), :step => 3
  
  
  def initialize(color, x, y)
    @color = color
    @x, @y = x , y
    start_animations! # Start animations when created
  end

  # This method can be named anything you want
  def display
    matrix do
      color @color
      translate @x, @y
      rotate @angle
      triangle [0,0], [60,100], [0,100]
    end
  end

end

class Boxes < OpenGL::App
  setup2D!

  
  def initialize(width, height, name)
    super(width, height, name)
    
    @red = Box.new("#f00", 100, 150)
    @blue = Box.new("#00f", 300, 150)
  end
  
  def display
    clear "#fff" # white background
    
    @red.display
    @blue.display
  end
  
end
    
app = Boxes.new(400, 300, __FILE__) # create new application with 400x300 window 
app.start # start application
