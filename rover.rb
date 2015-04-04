class Rover

  def initialize(x, y, heading)
    @x = x
    @y = y
    @heading = heading
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
