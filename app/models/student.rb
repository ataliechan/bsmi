class Student < ActiveRecord::Base
  
  has_many :preferences
  has_many :timeslots, :through => :preferences
  
end
