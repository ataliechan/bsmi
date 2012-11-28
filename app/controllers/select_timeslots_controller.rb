class SelectTimeslotsController < ApplicationController
  include Wicked::Wizard
  steps :monday, :tuesday, :wednesday, :thursday, :friday, :rank, :summary
  
  def show
    @semester = Semester.find(params[:semester_id])
    @cal_course = CalCourse.find(params[:cal_course_id])
    @student = User.find(params[:student_id]).owner
    @timeslots = Timeslot.where(:day => Timeslot.day_index(step), :cal_course_id => params[:cal_course_id])

    case step
    when :rank
      @timeslots = Timeslot.find(@student.preferences.map{ |p| p.timeslot_id })
      @preferences = @student.preferences
    end

    case step
    when :summary
      @timeslots = Timeslot.find(@student.preferences.map{ |p| p.timeslot_id })
      @preferences = @student.preferences.order("ranking ASC")
    end

    render_wizard 
  end

  def update
    @semester = Semester.find(params[:semester_id])
    @cal_course = CalCourse.find(params[:cal_course_id])
    @student = User.find(params[:student_id]).owner

    case step
    when :cal_course_selection
      params[:student][:cal_courses].each_value do |v|
        CalCourse.find(v) << @student
      end

    end

    case step
    when :rank
      valid = true
      Preference.transaction do 
        params[:student][:preferences_attributes].each_value do |v|
          p = Preference.find_by_id(v[:id])
          p.ranking = nil
          p.save!(:validate => false)
        end
        
        params[:student][:preferences_attributes].each_value do |v|
          p = Preference.find_by_id(v[:id])
          p.ranking = v[:ranking]
          if not p.valid?
            valid = false
            flash[:error] = "The ranking for preference must be unique."
            raise ActiveRecord::Rollback
          end
          p.save
        end
      end
      
      if valid
        render_wizard @student
      else
        redirect_to wizard_path
      end
    end

    case step
    when :monday, :tuesday, :wednesday, :thursday, :friday
        current = []
        from_form = []

        Preference.where(:student_id => @student.id).each do |p|
          if p.timeslot.day == step
            current << p.id
          end
        end
        
        if params[step]
          params[step].each do |timeslot_id|
            p = Preference.find_by_student_id_and_timeslot_id(@student.id, timeslot_id)
            if not p
              p = Preference.create(:student_id => @student.id, :timeslot_id => timeslot_id)
            end
            from_form << p.id
          end
        end

        intersection = current & from_form
        deleted = current - intersection

        deleted.each do |preference_id|
          Preference.delete(preference_id)
        end

        @student.fix_ranking_gap

      if params[:commit] == 'Save'
        redirect_to wizard_path
      elsif params[:commit] == 'Save & Continue'
        render_wizard @student
      end
    end  

  end

end
