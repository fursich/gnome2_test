require './gtk_window.rb'
require 'matrix'

class Line
  attr_accessor :point1, :point2
  UNIT_HEIGHT = Math.sqrt(3) * 0.5
  ROTATOR = Matrix[[0.5, UNIT_HEIGHT], [-UNIT_HEIGHT, 0.5]]

  def initialize(vector1, vector2)
    @point1 = vector1
    @point2 = vector2
  end

  def split!
    [
      self.class.new(point1, first_point),
      self.class.new(first_point, second_point),
      self.class.new(second_point, third_point),
      self.class.new(third_point, point2),
    ]
  end

  private
  def unit_vector
    (point2 - point1) / 3.0
  end

  def first_point
    point1 + unit_vector
  end

  def second_point
    first_point + ROTATOR * unit_vector
  end

  def third_point
    point2 - unit_vector
  end
end

class Fractal
  attr_accessor :lines

  def initialize(x0, y0, x1, y1)
    @lines = [
      Line.new(vector(x0, y0), vector(x1, y1))
    ]
  end

  def split!
    @lines = @lines.flat_map{ |line| line.split!}
    self
  end

  def draw_line(content)
    content.move_to *first_point.to_a

    lines.each do |line|
      content.line_to(*line.point2.to_a)
    end
  end

  private

  def vector(x,y)
    Vector[x, y]
  end

  def first_point
    lines.first.point1
  end
end


window = GtkWindow.new(1000, 600)
shape = Fractal.new(50, 500, 950, 500)

6.times do
  shape.split!
end

window.draw_content do |content|
  shape.draw_line(content)
end
window.draw
