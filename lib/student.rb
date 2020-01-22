#require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM students
    SQL

    # remember each row should be a new instance of the Student class
    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end #map
  end #self.all

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end #map
  end #self.all_students_in_grade_9

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end #map
  end #self.students_below_12th_grade

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    all_rows = DB[:conn].execute(sql, num)
    all_rows.map do |row|
      self.new_from_db(row)
    end #map
  end #self.first_X_students_in_grade_10

  def self.first_student_in_grade_10 
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end[0] #map
  end #self.first_student_in_grade_10

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    all_rows = DB[:conn].execute(sql, grade)
    all_rows.map do |row|
      self.new_from_db(row)
    end #map
  end #self.all_students_in_grade_X

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    # return a new instance of the Student class
    # don't need to use .map since there's only one instance being created...

    # DB[:conn].execute(sql, name).map do |row|
    #   self.new_from_db(row)
    # end.first #map

    a_row = DB[:conn].execute(sql, name)[0]
    the_student = self.new_from_db(a_row)

  end #self.find_by_name
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
