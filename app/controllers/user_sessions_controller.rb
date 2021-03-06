class UserSessionsController < ApplicationController
  before_filter :require_user, :only => [:destroy]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"

      if @user_session.user and @user_session.user.owner_type == "Student"
        redirect_to home_student_path(@user_session.user.owner_id)
      elsif @user_session.user and @user_session.user.owner_type == "Advisor"
        redirect_to settings_path
      elsif @user_session.user and @user_session.user.owner_type == "MentorTeacher"
        redirect_to home_mentor_teacher_path(@user_session.user.owner_id)
      elsif @user_session.user and @user_session.user.owner_type == "CalFaculty"
        redirect_to cal_faculty_home_index_path
      else
        redirect_back_or_default account_url(@current_user)
      end
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_path
  end
end
