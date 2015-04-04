class Rover
  attr_reader :x, :y, :heading

  def initialize(plateau)
    puts "What is the rover's position?  (0,0) is the lower left (SW corner) of the plateau. Please enter as its x and y coordinates and heading with spaces i.e. 5 5 N"
    start_position(plateau)
  end

  def start_position(plateau)
    position = gets.chomp.upcase.split
    @x = position[0].to_i
    @y = position[1].to_i
    @heading = position[2]

    if plateau.collide?(@x, @y)
      puts "There is another rover at this position. Please provide a new position."
      start_position(plateau)
    end

    if plateau.fall?(@x, @y)
      puts "Your chosen starting position is off the plateau grid. Please provide a new position."
      start_position(plateau)
    end
  end

  #Rover updates position to confirmed position from requester.
  def move(requester)
    @x = requester.check_x
    @y = requester.check_y
  end

  #track_heading tracks changes with direction as assignment by increment/decrement from array of values.  Allows us to keep track of heading as we check if instructions are valid.
  def turn(direction)
    compass_points = ['N', 'E', 'S', 'W']

    if direction == 'R' && @heading == 'W'
      @heading = 'N'
    elsif direction == 'R'
      @heading = compass_points[(compass_points.index(@heading) + 1)]
    else
      @heading = compass_points[(compass_points.index(@heading) - 1)]
    end
  end
end

#MissionControl is responsible for assigning and ordering rovers around
class MissionControl
  attr_reader :check_x, :check_y, :check_heading, :rover_list
  def initialize(plateau)
    @plateau = plateau
    puts "Welcome to Mission Control.  How many rovers would you like to deploy?"
    gets.chomp.to_i.times{run_rover_commands}
  end

  def get_instructions(rover)
    puts "Where would you like the rover to move? Enter L for left, R for right and M for forward in the current heading i.e. LMMMMRMMMRMMMLM"
    read_instructions(rover, gets.chomp.upcase.split(""))
  end

  def read_instructions(rover, set_of_instructions)
    print "These instructions were executed: "
    set_of_instructions.each do |instruction|
      if instruction == 'M'
        next_move(rover)
        rover.move(self) unless stop_rover?(rover)
      else
        rover.turn(instruction)
      end
      print instruction
    end
    @plateau.rover_list.push(rover)
  end

  def stop_rover?(rover)
    if @plateau.fall?(@check_x, @check_y)
      puts "\nThe next instruction M would make the rover fall off the plateau. The rover has stopped safely at #{rover.x}, #{rover.y} heading #{rover.heading}. Please provide new instructions."
      get_instructions(rover)
    elsif @plateau.collide?(@check_x, @check_y)
      puts "\nThe next instruction M would make the rover crash into another rover. The rover has stopped safely at #{rover.x}, #{rover.y} heading #{rover.heading}. Please provide new instructions."
      get_instructions(rover)
    end
  end

  #next_move tracks next location as assignment by increment/decrement based on heading
  def next_move(rover)
    @check_x, @check_y = rover.x, rover.y
    case rover.heading
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

  def run_rover_commands
    rover = Rover.new(@plateau)
    get_instructions(rover)
    puts "\nThe rover is now at #{rover.x}, #{rover.y} heading #{rover.heading}."
  end
end

class Plateau
  attr_accessor :rover_list
  def initialize
    puts "How big is the plateau?  ___ by ___? (Please enter the numbers like this: 5 5)."
    size = gets.chomp.split
    @max_x = size[0].to_i
    @max_y = size[1].to_i
    @rover_list = []
  end

  def fall?(x, y)
    x > @max_x || y > @max_y
  end

  def collide?(x, y)
    @rover_list.each do |listed_rover|
      if x == listed_rover.x && y == listed_rover.y
        return true
        break
      end
    end
    false
  end
end

tharsis = Plateau.new
nasa = MissionControl.new(tharsis)