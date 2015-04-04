class Rover

  def initialize(position) #Array created from split of user input
    @x = position[0].to_i
    @y = position[1].to_i
    @heading = position[2]
  end

  #The SW corner of the grid is 0,0
  def move
    case @heading
      when 'N'
        @y += 1
      when 'S'
        @y -= 1
      when 'E'
        @x += 1
      when 'W'
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
def read_instruction(rover, set_of_instructions)
  set_of_instructions.each do |instruction|
    if instruction == 'M'
      rover.move
    else
      rover.turn(instruction)
    end
  end
end

#Splits

#Prompt for plateau size as first line of input.  Not used in code yet so gets is called but nothing stored yet.
puts "How big is the plateau?  ___ by ___? (Please enter the numbers like this: 5 5)."
gets.chomp.split

#Get starting position to create rover instance
puts "What is Rover 1's position?  (0,0) is the lower left (SW corner) of the plateau.  Please enter as its x and y coordinates and heading with spaces i.e. 5 5 N"
rover1 = Rover.new(gets.chomp.upcase.split)

#Get set of instructions from user
puts "Where would you like the rover to move? Enter L for left, R for right and M for forward in the current heading i.e. LMMMMRMMMRMMMLM"
read_instruction(rover1, gets.chomp.upcase.split(""))