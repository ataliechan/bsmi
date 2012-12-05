class TimeslotsController < ApplicationController
  def destroy
    @name = Student.find_by_id(params[:student_id]).first_name + Student.find_by_id(params[:student_id]).last_name
    @placements = Student.find_by_id(params[:student_id]).placements
    @placements.delete(Timeslot.find_by_id(params[:timeslot_id]))
    redirect_to "students", :notice => "The selected placement has been removed for #{@name}"
  end
end
