# Ruby DSL for ffi-opengl


Tested on ruby 1.9.2

![Example](http://cl.ly/a984a5d7ac920118646c/content)

# Requirements
    ruby 1.9.2

# Instalation
    gem install ffi-opengl-dsl
    
# Usage

    # See exampes/basic.rb
    require "ffi-opengl-dsl"
    
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