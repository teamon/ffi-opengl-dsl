module OpenGL
  module Helpers
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      include GL
      include Math
      
      # Wrappers for #glBegin(_MODE_) and #glEnd
      #
      # @example
      #   quads do
      #     vertex -50, -50
      #     vertex -50,  50    
      #     vertex  50,  50
      #     vertex  50, -50
      #   end
      # 
      #   # is equivalent to
      # 
      #   glBegin(GL_QUADS)
      #     glVertex2f(-50, -50)
      #     glVertex2f(-50,  50)   
      #     glVertex2f( 50,  50)
      #     glVertex2f( 50, -50)
      #   glEnd
      # 
      # @param [Proc]
      # @see http://www.ugrad.cs.ubc.ca/~cs314/opengl/glBegin.html
      %w(GL_POINTS GL_LINES GL_LINE_STRIP
      	GL_LINE_LOOP GL_TRIANGLES GL_TRIANGLE_STRIP GL_TRIANGLE_FAN
      	GL_QUADS GL_QUAD_STRIP GL_POLYGON).each do |mode|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{mode.to_s.downcase.gsub('gl_', '')}
            glBegin(#{mode})
            yield
            glEnd
          end
        RUBY
      end

      # Wrapper for #glPushMatrix and #glPopMatrix
      #
      # @example
      #   matrix do
      #     foo
      #   end
      #   
      #   # is equivalent to
      #
      #   glPushMatrix
      #   foo
      #   glPopMatrix
      # 
      # @param [Proc]
      def matrix
        glPushMatrix
        yield
        glPopMatrix
      end
      
      # Draws quad between four points
      #
      # @example
      #   quad [0,0], [40, 0], [40, 40], [0, 40]
      # 
      # @param *args list of points 
      def quad(*args)
        quads do
          args.each {|v| vertex *v }
        end
      end
      
      # Draws triangle between three points
      #
      # @example
      #   triangle [0,0], [40, 0], [40, 40]
      #
      # @param *args list of points 
      def triangle(*args)
        triangles do
          args.each {|v| vertex *v }
        end
      end
    
      # Wrapper for glVertex*
      # If z param is not specified calls #glVertex2f else #glVertex3f
      #
      # @param [Float, Fixnum] x x coordinate
      # @param [Float, Fixnum] y y coordinate
      # @param [Float, Fixnum] z z coordinate
      def vertex(x, y, z=nil)
        if z
          glVertex3f(x, y, z)
        else
          glVertex2f(x, y)
        end
      end
   
      # Wrapper for glTranslatef
      #
      # If given block it puts translation+block in matrix
      #
      # @example
      #   translate 30, 50 # move 30 units right and 50 top
      #
      # @example
      #   translate 10, 10 do
      #     # ...
      #   end
      #
      #   # is equivalent to
      #
      #   matrix do
      #     translate 10, 10
      #     # ...
      #   end
      #
      # @param [Float, Fixnum] x x coordinate
      # @param [Float, Fixnum] y y coordinate
      # @param [Float, Fixnum] z z coordinate
      def translate(x, y, z = 0.0, &block)
        if block_given?
          matrix do
            glTranslatef(x.to_f, y.to_f, z.to_f)
            yield
          end
        else
          glTranslatef(x.to_f, y.to_f, z.to_f)
        end
      end
   
      # Wrapper for glRotatef
      # In 2D mode if only angle is specified rotation is done around z-axis
      # If given block it puts translation+block in matrix
      #
      # @example
      #   rotate 45 # rotate 45 degrees around z-axis
      #
      # @example
      #   rotate 45 do
      #     # ...
      #   end
      #
      #   # is equivalent to
      #
      #   matrix do
      #     rotate 45
      #     # ...
      #   end
      #
      # @param [Float, Fixnum] angle rotation angle
      # @param [Float, Fixnum] x x coordinate
      # @param [Float, Fixnum] y y coordinate
      # @param [Float, Fixnum] z z coordinate
      def rotate(angle, x = nil, y = nil,  z = nil)
        z ||= 1.0 if OpenGL::App.use2D
        if block_given?
          matrix do
            glRotatef(angle.to_f, x || 0.0, y || 0.0, z)
            yield
          end
        else
          glRotatef(angle.to_f, x || 0.0, y || 0.0, z)
        end
      end
   
      # Set drawing color
      #
      # @example
      #   color "#ff0"
      #   color 0.8, 0.9, 9.8
      #   color "#ff9900cc"
      #
      # @overload color(name)
      #   Sets color using hex string
      #   @param [String] name
      #
      # @overload color(r, g, b, a = 1.0)
      #   Sets color using float values (form 0.0 to 1.0)
      #   @param [Float] r - red color value
      #   @param [Float] g - green color value
      #   @param [Float] b - blue color value
      #   @param [Float] a - opacity
      # 
      # @see examles/colors.rb
      def color(r, g = nil, b = nil, a = 1.0)
        glColor4f *_parse_color(r, g, b, a)
      end
   
      # Set background clear color
      #
      # @example
      #   color "#ff0"
      #   color 0.8, 0.9, 9.8
      #   color "#ff9900cc"
      #
      # @overload color(name)
      #   Sets color using hex string
      #   @param [String] name
      #
      # @overload color(r, g, b, a = 1.0)
      #   Sets color using float values (form 0.0 to 1.0)
      #   @param [Float] r - red color value
      #   @param [Float] g - green color value
      #   @param [Float] b - blue color value
      #   @param [Float] a - opacity
      # 
      # @see examles/colors.rb
      #
      def clear(r, g = nil, b = nil, a = 1.0)
        glClearColor *_parse_color(r, g, b, a)
      end
      
      # Draw rectangle
      #
      # @param [Float, Fixnum] width rectangle width
      # @param [Float, Fixnum] height rectangle height
      def rect(width, height)
        w2 = width/2
        h2 = height/2
        quads do
          vertex -w2,  h2
          vertex  w2,  h2
          vertex  w2, -h2
          vertex -w2, -h2
        end
      end
      
      # Draw square
      #
      # @param [Float, Fixnum] width square width
      def square(width)
        rect width, width
      end
      
      # Draw circle
      #
      # @param [Float, Fixnum] r circle radius
      # @param [Fixnum] slices number of subdivisions around the z axis
      # @param [Fixnum] loops number of concentric rings about the origin into which the disk is subdivided
      # @see http://pyopengl.sourceforge.net/documentation/manual/gluDisk.3G.xml gluDisk documentation
      def circle(r, slices = 24, loops = 10)
        gluDisk(gluNewQuadric, 0, r, slices, loops)
      end
      
      # Draw ellipse
      #
      # @param [Float, Fixnum] rx ellipse x-radius
      # @param [Float, Fixnum] ry ellipse y-radius
      def ellipse(rx, ry)
        polygon do
          (0..2*PI).step(0.1).each do |a|
            vertex rx*cos(a), ry*sin(a)
          end
        end
      end
      
      # Draw ring
      #
      # @param [Float, Fixnum] ro ring outer radius
      # @param [Float, Fixnum] ri ring inner radius
      # @param [Fixnum] slices number of subdivisions around the z axis
      # @param [Fixnum] loops number of concentric rings about the origin into which the disk is subdivided
      # @see http://pyopengl.sourceforge.net/documentation/manual/gluDisk.3G.xml gluDisk documentation
      def ring(ri, ro, slices = 24, loops = 10)
        gluDisk(gluNewQuadric, ri, ro, slices, loops)
      end
      
      # Draw arc
      #
      # @param [Float, Fixnum] ro arc outer radius
      # @param [Float, Fixnum] ri arc inner radius
      # @param [Float] start starting angle (degrees)
      # @param [Float] angle sweep angle (degrees)
      # @param [Fixnum] slices number of subdivisions around the z axis
      # @param [Fixnum] loops number of concentric rings about the origin into which the disk is subdivided
      # @see http://pyopengl.sourceforge.net/documentation/manual/gluDisk.3G.xml gluDisk documentation
      def arc(ri, ro, start, angle, slices = 24, loops = 10)
        gluPartialDisk(gluNewQuadric, ri, ro, slices, loops, start, angle)
      end
   
      protected
   
      # Parse color from string ar float values
      #
      # @example
      #   _parse_color "#ff0"         # => [1.0, 1.0, 0, 1.0]
      #   _parse_color 0.8, 0.9, 0.7  # => [0.8, 0.9, 0.7, 1.0]  
      #   _parse_color "#ff9900cc"    # => [1.0, 0.6, 0, 0.8]
      #
      # @overload color(name)
      #   Parse color from hex string
      #   @param [String] name
      #
      # @overload color(r, g, b, a = 1.0)
      #   Parse color from float values (form 0.0 to 1.0)
      #   @param [Float] r - red color value
      #   @param [Float] g - green color value
      #   @param [Float] b - blue color value
      #   @param [Float] a - opacity
      # 
      # @see examles/colors.rb
      #
      def _parse_color(r, g = nil, b = nil, a = 1.0)
        if r.is_a?(String)
          name = r
          if name =~ /^#[0-9a-fA-F]{3,4}$/
            r,g,b,a = name[1..4].scan(/./).map {|c| (c*2).to_i(16)/255.0 }
          elsif name =~ /^#[0-9a-fA-F]{6,8}$/
            r,g,b,a = name[1..8].scan(/../).map {|c| c.to_i(16)/255.0 }
          else
            raise ArgumentError.new("Color string is invalid")
          end
   
          [r, g, b, a || 1.0]
        else
          [r, g, b, a]
        end
      end
     
    end

    
 
  end # Helpers
end # OpenGL