class Rover

  def initialize(x, y, heading)
    @x = x
    @y = y
    @heading = heading
  end

  #The SW corner of the grid is 0,0
  def move
    case rover_heading
      when @heading == 'N'
        @y += 1
      when @heading == 'S'
        @y -= 1
      when @heading == 'E'
        @x += 1
      when @heading == 'W'
        @x -= 1
      end
  end

  #Heading changes with direction as assignment by increment/decrement from array of values
  def turn(direction)
    compass_points = ['N', 'E', 'S', 'W']
    if direction == 'R' && @heading == 'W'
      @heading = 'N'
    elsif direction == 'R'
      @heading = compass_points[compass_points.index(@heading) + 1]
    else
      @heading = compass_points[compass_points.index(@heading) - 1]
  end
end

#Accept instruction and decide whether to tell rover to turn or move
def read_instruction(instruction)
  if instruction == 'M'
    rover.move
  else
    rover.turn(direction)
  end
end
