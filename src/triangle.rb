# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  raise TriangleError unless triangle?(a, b, c)

  return :equilateral if a == b && b == c
  return :isosceles if a == b || a == c || b == c

  :scalene
end

def triangle?(a, b, c)
  return false if [a, b, c].include?(0) || [a, b, c].any?(&:negative?)
  return false if a + b <= c || a + c <= b || b + c <= a

  true
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
