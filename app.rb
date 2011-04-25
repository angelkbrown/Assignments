require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'active_support'
require 'mysql'
require 'sinatra'
require 'haml'
require 'json'

ActiveRecord::Base.configurations = YAML::load(File.open("database.yml"))

require File.expand_path('models', File.dirname(__FILE__))

get '/' do
    @student = Student.find(:first)
    if @student.nil?
    	erb :failure
    else
    	haml :student
    end
end

get '/faculty?' do 
	@faculty = Person.find(params[:id])
	@assignmentsets = AssignmentSet.find(:all)
    if @faculty.nil?
    	erb :failure
    else
    	haml :faculty
    end	
end

get '/login?' do
  @title = 'Login'
  haml :login
end

get '/allfaculty' do
	@faculties = Faculty.find(:all)
    if @faculties.nil?
    	erb :failure
    else
    	haml :allfaculty
    end	
end

get '/assignment' do
	@assignment = Assignment.find(:first)
    if @assignment.nil?
    	erb :failure
    else
    	haml :assignment
    end		
end

get '/assignments?' do
	content_type :json
	@assignments = Assignment.find_by_sql('select * from assignments where faculty_id='+params[:faculty]+' and assignment_set_id='+params[:set])
	@mentees=Array.new
	@assignments.each do |assn|
		@bio = Person.find(assn.student_id)
		@student = @bio.student
		@person = Array.new
		@person<<@bio
		@person<<@student
		@mentees<<@person
	end
	@mentees.to_json
end

get '/assignmentsets' do 
	@assignmentsets = AssignmentSet.find(:all)
    if @assignmentsets.nil?
    	erb :failure
    else
    	haml :assignmentsets
    end		
end

get '/assignmentset?' do
	@assignmentset = AssignmentSet.find_by_sql('select * from assignment_sets where id = ' + params[:id])
    if @assignmentset.nil?
    	erb :failure
    else
    	haml :assignmentset
    end		
end	

get '/newset' do
	@initialset = AssignmentSet.create(:state=>"initial", :start_date=>Time.now, :end_date=>Time.now)
	@initialset.save
	@workingset = AssignmentSet.create(:state=>"working", :start_date=>Time.now)
	@workingset.save
	@mentors = Mentor.find_by_sql("select * from mentors")
	@mentors.each do |mentor|
		@assignment = Assignment.create(:student_id=>mentor.student_id, :faculty_id=>mentor.faculty_id, :assignment_set_id=>@initialset.id)
		@assignment.save
		@workingassignment = Assignment.create(:student_id=>mentor.student_id, :faculty_id=>mentor.faculty_id, :assignment_set_id=>@workingset.id)		
		@workingassignment.save
	end
	@assignmentsets = AssignmentSet.find(:all)
	haml :assignmentsets

end

get '/commit' do
	
end
