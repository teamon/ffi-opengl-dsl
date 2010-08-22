module OpenGL
  module Helpers
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    module InstanceMethods
      include GL

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
   
      # Wrapper for #glBegin(GL_QUADS) and #glEnd
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
      def quads(&block)
        with(GL_QUADS, &block)
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
   
      # Wrapper for #glBegin(GL_TRIANGLES) and #glEnd
      #
      # @example
      #   triangles do
      #     vertex  0,  0
      #     vertex 50, 50    
      #     vertex 20, 30
      #   end
      # 
      #   # is equivalent to
      # 
      #   glBegin(GL_TRIANGLES)
      #     glVertex2f( 0,  0)
      #     glVertex2f(50, 50)   
      #     glVertex2f(20, 30)
      #   glEnd
      # 
      # @param [Proc]
      def triangles(&block)
        with(GL_TRIANGLES, &block)
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
   
      # Wrapper for #glBegin(_SOMETHING_) and #glEnd
      #
      # @example
      #   with(GL_LINES) do
      #     vertex  0,  0
      #     vertex 50, 50    
      #     vertex 20, 30
      #   end
      # 
      #   # is equivalent to
      # 
      #   glBegin(GL_LINES)
      #     glVertex2f( 0,  0)
      #     glVertex2f(50, 50)   
      #     glVertex2f(20, 30)
      #   glEnd
      # 
      # @param [Proc]
      def with(what)
        glBegin(what)
        yield
        glEnd
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
      # @example
      #   translate 30, 50 # move 30 units right and 50 top
      #
      # @param [Float, Fixnum] x x coordinate
      # @param [Float, Fixnum] y y coordinate
      # @param [Float, Fixnum] z z coordinate
      def translate(x, y, z = 0.0)
        glTranslatef(x.to_f, y.to_f, z.to_f)
      end
   
      # Wrapper for glRotatef
      # In 2D mode if only angle is specified rotation is done around z-axis
      #
      # @example
      #   rotate 45 # rotate 45 degrees around z-axis
      #
      # @param [Float, Fixnum] angle rotation angle
      # @param [Float, Fixnum] x x coordinate
      # @param [Float, Fixnum] y y coordinate
      # @param [Float, Fixnum] z z coordinate
      def rotate(angle, x = nil, y = nil,  z = nil)
        z ||= 1.0 if OpenGL::App.use2D
        glRotatef(angle.to_f, x || 0.0, y || 0.0, z)
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