class Person
  attr_writer :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hi, my name is #{@name}"
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

instructor = Instructor.new("Chris")
instructor.greet

student = Student.new("Cristina")
student.greet

instructor.teach
student.learn
#student.teach would not work as it is in instance method for instructor.  student has no access to this method.