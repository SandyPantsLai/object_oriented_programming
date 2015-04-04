class Rover
  attr_reader :x, :y, :heading

  def initialize(position) #Array created from split of user input
    @x = position[0].to_i
    @y = position[1].to_i
    @heading = position[2]
  end

  #The SW corner of the grid is 0,0
  def move(requester)
    @x = requester.check_x
    @y = requester.check_y
    @heading = requester.check_heading
  end
end

#   #Heading changes with direction as assignment by increment/decrement from array of values
#   def turn
#       @heading = @check_heading
#   end
# end

#MissionControl is responsible for assigning and ordering rovers around
class MissionControl
  attr_reader :check_x, :check_y, :check_heading
  def initialize(plateau)
    @plateau = plateau
    puts "Welcome to Mission Control.  How many rovers would you like to deploy?"
    gets.chomp.to_i.times{run_rover_commands}
  end

  def add_rover
    puts "What is the rover's position?  (0,0) is the lower left (SW corner) of the plateau.  Please enter as its x and y coordinates and heading with spaces i.e. 5 5 N"
    Rover.new(gets.chomp.upcase.split)
  end

  def get_instructions(rover)
    puts "Where would you like the rover to move? Enter L for left, R for right and M for forward in the current heading i.e. LMMMMRMMMRMMMLM"
    set_of_instructions = gets.chomp.upcase.split("")
    read_instructions(rover, set_of_instructions)
  end

  def read_instructions(rover, set_of_instructions)
    @check_x, @check_y, @check_heading = rover.x, rover.y, rover.heading #check_variables allow for a check if proposed route will cause issues without changing original position.""
    set_of_instructions.each do |instruction|
      if instruction == 'M'
        check_location
        if @plateau.fall?(self)
          puts "These instructions would make the rover fall off the plateau.  Please provide new instructions."
          get_instructions(rover)
          break
        end
      else
        track_heading(instruction)
      end
    end
    rover.move(self)
  end

    def check_location
    case @check_heading
      when 'N'
        @check_y += 1
      when 'S'
        @check_y -= 1
      when 'E'
        @check_x += 1
      when 'W'
        @check_x -= 1
    end
  end

  #Heading changes with direction as assignment by increment/decrement from array of values.  Allows us to keep track of heading as we check if instructions are valid.
  def track_heading(direction)
    compass_points = ['N', 'E', 'S', 'W']
    p @check_heading
    p compass_points.index(@check_heading)

    if direction == 'R' && @check_heading == 'W'
      @check_heading = 'N'
    elsif direction == 'R'
      @check_heading = compass_points[(compass_points.index(@check_heading) + 1)]
    else
      @check_heading = compass_points[(compass_points.index(@check_heading) - 1)]
    end
  end

  def run_rover_commands
    rover = add_rover
    get_instructions(rover)
    puts "The rover is now at #{rover.x}, #{rover.y} heading #{rover.heading}."
  end
end

class Plateau
  def initialize
    puts "How big is the plateau?  ___ by ___? (Please enter the numbers like this: 5 5)."
    size = gets.chomp.split
    @max_x = size[0].to_i
    @max_y = size[1].to_i
  end

  def fall?(requester)
    requester.check_x > @max_x || requester.check_y > @max_y
  end
end


tharsis = Plateau.new
nasa = MissionControl.new(tharsis)