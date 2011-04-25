
class Student < ActiveRecord::Base
  establish_connection :oracle
  belongs_to :person
  has_many :person_majors, :finder_sql => 'select * from person_majors where person_id=#{person_id}'
  has_many :majors, :through => :person_majors
end

class Faculty < ActiveRecord::Base
	establish_connection :oracle
	belongs_to :school
	belongs_to :person
	has_many :assignments, :finder_sql => 'select * from assignments where faculty_id=#{person_id}'	
end

class Person < ActiveRecord::Base
	establish_connection :oracle
	has_one :faculty
	has_one :student
end

class School < ActiveRecord::Base
	establish_connection :oracle
	has_many :faculties
end

class Assignment < ActiveRecord::Base
	establish_connection :mysql
	belongs_to :faculty, :class_name => "Person"
	belongs_to :student, :class_name => "Person"
end

class AssignmentSet < ActiveRecord::Base
	establish_connection :mysql
	has_many :assignments
end

class Mentor < ActiveRecord::Base
	establish_connection :oracle
end

class Major < ActiveRecord::Base
	establish_connection :oracle
end

class PersonMajor < ActiveRecord::Base
	establish_connection :oracle
	belongs_to :student, :class_name => "Person"
	belongs_to :major
end
