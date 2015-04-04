class Rover

  def initialize(position) #Array created from split of user input
    @x = position[0]
    @y = position[1]
    @heading = position[2]
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
end

#Accept instruction and decide whether to tell rover to turn or move
def read_instruction(instruction)
  if instruction == 'M'
    rover.move
  else
    rover.turn(direction)
  end
end

#Splits

#Prompt for plateau size as first line of input.  Not used in code yet so gets is called but nothing stored yet.
puts "How big is the plateau?  ___ by ___? (Please enter the numbers like this: 5 5)."
gets.chomp.split

#Get starting position to create rover instance
puts "What is Rover 1's position?  (0,0) is the lower left (SW corner) of the plateau.  Please enter as its x and y coordinates and heading with spaces i.e. 5 5 N"
rover1 = Rover.new(gets.chomp.upcase.split)