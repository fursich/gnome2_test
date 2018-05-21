require 'gtk3'

class GtkWindow
  attr_accessor :width, :height, :window, :drawing_area

  def initialize(width, height)
    @width  = width
    @height = height

    @window = Gtk::Window.new
    @window.set_size_request(@width, @height)

    @drawing_area = Gtk::DrawingArea.new
    @drawing_area.set_size_request(@width, @height)
  end

  def draw_content(&block)
    drawing_area.signal_connect(:draw) do
      context = drawing_area.window.create_cairo_context
      context.scale 0.5, 0.5

      # background color
      context.set_source_rgb(0.0, 0.0, 0.0)
      context.paint 1.0

      # fill color
      context.set_source_rgb(1.0, 1.0, 1.0)
      #arc(x, y, z, start, end)
      # context.arc(width / 2, height / 2, 150, 10 , 0.5 * Math::PI)
      # context.fill
      yield context
      context.stroke
    end
  end

  def draw
    fixed = Gtk::Fixed.new
    fixed.put(drawing_area, 0, 0)
    window.add(fixed)

    window.show_all
    window.signal_connect(:destroy) {Gtk.main_quit}
    Gtk.main
  end
end
