class Person
  attr_writer :name

  def initialize(name)
    @name = name
  end
end

class Student < Person
  def learn
    puts "I get it!"
  end
end

class Instructor < Person
  def teach
    puts "Everything in Ruby is an Object"
  end
end

