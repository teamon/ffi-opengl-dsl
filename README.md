# Ruby DSL for ffi-opengl

This library provide extremely easy to use dsl for opengl.
While providing nice wrappers it still lets you use ALL gl* functions.
Currently, it provides only 2D helpers (but that will surely change).

Tested on ruby 1.8.6 and 1.9.2

[Documentation](http://yardoc.org/docs/frames/teamon-ffi-opengl-dsl)

NOTICE: This library is 100% experimental. It probably wont kill you, but may force you to kill ruby process.

![Example](http://cl.ly/58c4fcc41da303b006eb/content)

# Instalation
    gem install ffi-opengl-dsl
    
# Usage

    # See exampes/basic.rb
    require "ffi-opengl-dsl"
    
    class Basic < OpenGL::App
      setup2D!              # Needed for 2D setup
  
      def display
        clear "#fff"        # Clear background with white
    
        color "#00fa"       # You can use RGBA

        translate 100, 50   # Move 100 left and 50 up
        rotate 30           # Rotate 30 degrees
        rect 150, 90        # draw rectangle 150x90
      end
  
    end
    
    app = Basic.new(300, 200, "OpenGL with Ruby") # create new application with 300x200 window 
    app.start

    
# Examples
    
## Colors
    # See exampes/colors.rb
    color "#f00"
    color "#f00a" # RGBA
    color "#0000ff"
    color "#0000ffaa"
    color 0.1, 0.2, 0.8
    color 0.4, 0.9, 1.0, 0.9

    
## Animations
ffi-opengl-dsl have build it animation framework

    # See exampes/animations.rb
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
    
## Primitives
    square 100          # Square 100x100
    rect 200, 100       # Rectangle (width=200, height=100)
    circle 50           # Circle (radius=50)
    ring 40, 50         # Ring (inner radius=40, outer radius = 50)
    arc 30, 50, 15, 90  # Arc (inner radius=30, outer radius = 50, start angle = 15, angle = 90)
    