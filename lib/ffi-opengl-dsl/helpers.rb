module OpenGL
  module Helpers
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
    
    module InstanceMethods
      include GL

      def matrix
        glPushMatrix
        yield
        glPopMatrix
      end
   
      def quads(&block)
        with(GL_QUADS, &block)
      end
   
      def quad(*args)
        quads do
          args.each {|v| vertex *v }
        end
      end
   
      def triangles(&block)
        with(GL_TRIANGLES, &block)
      end
   
      def triangle(*args)
        triangles do
          args.each {|v| vertex *v }
        end
      end
   
      def with(what)
        glBegin(what)
        yield
        glEnd
      end
   
      def vertex(x, y, z=nil)
        if z
          glVertex3f(x, y, z)
        else
          glVertex2f(x, y)
        end
      end
   
      def translate(x, y, z = 0.0)
        glTranslatef(x.to_f, y.to_f, z.to_f)
      end
   
      def rotate(angle, x = nil, y = nil,  z = nil)
        z ||= 1.0 if OpenGL::App.use2D
        glRotatef(angle.to_f, x || 0.0, y || 0.0, z)
      end
   
      def color(name)
        glColor4f *_parse_color(name)
      end
   
      def clear(name)
        glClearColor *_parse_color(name)
      end
   
      protected
   
      def _parse_color(name)
        if name.is_a?(String)
          if name =~ /^#[0-9a-fA-F]{3,4}$/
            r,g,b,a = name[1..4].scan(/./).map {|c| (c*2).to_i(16)/255.0 }
          elsif name =~ /^#[0-9a-fA-F]{6,8}$/
            r,g,b,a = name[1..8].scan(/../).map {|c| c.to_i(16)/255.0 }
          else
            raise ArgumentError.new("Color string is invalid")
          end
   
          [r, g, b, a || 1.0]
        else
          raise ArgumentError.new("Color is invalid")
        end
      end
     
    end
    
    module ClassMethods
      
    end
    
 
  end # Helpers
end # OpenGL