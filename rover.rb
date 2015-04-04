class Rover
  attr_reader :x, :y, :heading

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

#MissionControl is responsible for assigning and ordering rovers around
class MissionControl

  def initialize
    2.times{run_rover_commands}
  end

  def add_rover
    puts "What is the rover's position?  (0,0) is the lower left (SW corner) of the plateau.  Please enter as its x and y coordinates and heading with spaces i.e. 5 5 N"
    Rover.new(gets.chomp.upcase.split)
  end

  def get_instructions(rover)
    puts "Where would you like the rover to move? Enter L for left, R for right and M for forward in the current heading i.e. LMMMMRMMMRMMMLM"
    read_instruction(rover, gets.chomp.upcase.split(""))
  end

  def read_instruction(rover, set_of_instructions)
    set_of_instructions.each do |instruction|
      if instruction == 'M'
        rover.move
      else
        rover.turn(instruction)
      end
    end
  end

  def report_position(rover)
    puts "The rover is now at #{rover.x}, #{rover.y} heading #{rover.heading}."
  end

  def run_rover_commands
    rover = add_rover
    get_instructions(rover)
    report_position(rover)
  end
end

class Plateau
  def initialize
    puts "How big is the plateau?  ___ by ___? (Please enter the numbers like this: 5 5)."
    size = gets.chomp.split
    @max_x = size[0].to_i
    @max_y = size[1].to_i
  end
end

Plateau.new
MissionControl.new
