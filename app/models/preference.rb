class Preference < ActiveRecord::Base
  attr_protected #none  
  belongs_to :student
  belongs_to :timeslot

  #validates :ranking, :presence => true
  validates_uniqueness_of :ranking, :scope => [:student_id], :allow_null => true, :allow_blank => true

  validates :student_id, :presence => true
  validates :timeslot_id, :presence => true

end
