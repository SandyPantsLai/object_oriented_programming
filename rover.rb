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

  #Rover moves to verified position
  def move(requester)
    @x = requester.check_x
    @y = requester.check_y
  end

  def turn(direction)
    if (direction == "R" && @heading == "W") || (direction =="L" && @heading == "E")
      @heading = "N"
    elsif (direction == "R" && @heading == "E") || (direction =="L" && @heading == "W")
      @heading = "S"
    elsif (direction == "R" && @heading == "N") || (direction =="L" && @heading == "S")
      @heading = "E"
    else
      @heading = "W"
    end
  end
end

#MissionControl is responsible for assigning and ordering rovers around
class MissionControl
  attr_reader :check_x, :check_y, :check_heading, :rover_list
  def initialize
    puts "Bitmaker SpaceLabs Rover Deployment System.  Enter your city."
    `say "This is the Bitmaker SpaceLabs Rover Deployment System.  Which city are you in?"`
    greeting = "Welcome to #{gets.chomp.capitalize.strip} Mission Control."
    puts greeting + " Enter the names of the plateaux you wish to deploy rovers to, separated by commas:"
    `say "#{greeting}"`
    create_plateaux
  end

  def create_plateaux
    plateau_list = gets.chomp.upcase.split(",")
    plateau_list.each do |plateau_name|
      @plateau = Plateau.new(plateau_name.strip.capitalize)
      puts "How many rovers would you like to deploy?"
      gets.chomp.to_i.times{run_rover_commands}
    end
  end

  def get_instructions(rover)
    @check_x, @check_y = rover.x, rover.y
    puts "Where would you like the rover to move? Enter L for left, R for right and M for forward in the current heading i.e. LMMMMRMMMRMMMLM"
    read_instructions(rover, gets.chomp.upcase.split(""))
  end

  def read_instructions(rover, set_of_instructions)
    set_of_instructions.each do |instruction|
      if instruction == 'M'
          next_move(rover)
          break unless confirm_move(rover)
      else
        rover.turn(instruction)
      end
    end
    @plateau.rover_list.push(rover)
  end

  def confirm_move(rover)
    if @plateau.fall?(@check_x, @check_y) || @plateau.collide?(@check_x, @check_y)
      puts "Execution aborted.  The rover has stopped safely at #{rover.x}, #{rover.y} heading #{rover.heading}. Please provide new instructions."
      get_instructions(rover)
      return false
    else
      rover.move(self)
    end
  end

  #next_move tracks next location as assignment by increment/decrement based on heading
  def next_move(rover)
    case rover.heading
      when "N"
        @check_y += 1
      when "S"
        @check_y -= 1
      when "E"
        @check_x += 1
      when "W"
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
  attr_accessor :rover_list#, :plateau_name
  def initialize(plateau_name)
    puts "How big is #{plateau_name}?  ___ by ___? (Please enter the numbers like this: 5 5)."
    size = gets.chomp.split
    @max_x = size[0].to_i
    @max_y = size[1].to_i
    @rover_list = []
  end

  def fall?(x, y)
    if x < 0 || x > @max_x || y < 0 ||y > @max_y
      puts "The next instruction would make the rover fall off the plateau."
      return true
    end
    false
  end

  def collide?(x, y)
    @rover_list.each do |listed_rover|
      if x == listed_rover.x && y == listed_rover.y
        puts "The next instruction would make the rover crash into another rover."
        return true
      end
    end
    false
  end
end

MissionControl.new