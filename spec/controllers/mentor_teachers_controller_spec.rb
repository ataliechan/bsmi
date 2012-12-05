require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe MentorTeachersController do

  # This should return the minimal set of attributes required to create a valid
  # MentorTeacher. As you add validations to MentorTeacher, be sure to
  # update the return value of this method accordingly.
  def create_mentor_teacher
    FactoryGirl.create(:mentor_teacher)
  end

  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MentorTeachersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested mentor_teacher as @mentor_teacher" do
      mentor_teacher = create_mentor_teacher
      get :show, {:id => mentor_teacher.to_param}, valid_session
      assigns(:mentor_teacher).should eq(mentor_teacher)
    end
  end

  describe "GET new" do
    it "assigns a new mentor_teacher as @mentor_teacher" do
      get :new, {}, valid_session
      assigns(:mentor_teacher).should be_a_new(MentorTeacher)
    end
  end

  describe "GET edit" do
    it "assigns the requested mentor_teacher as @mentor_teacher" do
      mentor_teacher = create_mentor_teacher
      get :edit, {:id => mentor_teacher.to_param}, valid_session
      assigns(:mentor_teacher).should eq(mentor_teacher)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new MentorTeacher" do
        expect {
          post :create, {:mentor_teacher => valid_attributes}, valid_session
        }.to change(MentorTeacher, :count).by(1)
      end

      it "assigns a newly created mentor_teacher as @mentor_teacher" do
        post :create, {:mentor_teacher => valid_attributes}, valid_session
        assigns(:mentor_teacher).should be_a(MentorTeacher)
        assigns(:mentor_teacher).should be_persisted
      end

      it "redirects to the created mentor_teacher" do
        post :create, {:mentor_teacher => valid_attributes}, valid_session
        response.should redirect_to(MentorTeacher.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved mentor_teacher as @mentor_teacher" do
        # Trigger the behavior that occurs when invalid params are submitted
        MentorTeacher.any_instance.stub(:save).and_return(false)
        post :create, {:mentor_teacher => {}}, valid_session
        assigns(:mentor_teacher).should be_a_new(MentorTeacher)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        MentorTeacher.any_instance.stub(:save).and_return(false)
        post :create, {:mentor_teacher => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested mentor_teacher" do
        mentor_teacher = create_mentor_teacher
        # Assuming there are no other mentor_teachers in the database, this
        # specifies that the create_mentor_teacher
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        MentorTeacher.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => mentor_teacher.to_param, :mentor_teacher => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested mentor_teacher as @mentor_teacher" do
        mentor_teacher = create_mentor_teacher
        put :update, {:id => mentor_teacher.to_param, :mentor_teacher => valid_attributes}, valid_session
        assigns(:mentor_teacher).should eq(mentor_teacher)
      end

      it "redirects to the mentor_teacher" do
        mentor_teacher = create_mentor_teacher
        put :update, {:id => mentor_teacher.to_param, :mentor_teacher => valid_attributes}, valid_session
        response.should redirect_to(mentor_teacher)
      end
    end

    describe "with invalid params" do
      it "assigns the mentor_teacher as @mentor_teacher" do
        mentor_teacher = create_mentor_teacher
        # Trigger the behavior that occurs when invalid params are submitted
        MentorTeacher.any_instance.stub(:save).and_return(false)
        put :update, {:id => mentor_teacher.to_param, :mentor_teacher => {}}, valid_session
        assigns(:mentor_teacher).should eq(mentor_teacher)
      end

      it "re-renders the 'edit' template" do
        mentor_teacher = create_mentor_teacher
        # Trigger the behavior that occurs when invalid params are submitted
        MentorTeacher.any_instance.stub(:save).and_return(false)
        put :update, {:id => mentor_teacher.to_param, :mentor_teacher => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested mentor_teacher" do
      mentor_teacher = create_mentor_teacher
      expect {
        delete :destroy, {:id => mentor_teacher.to_param}, valid_session
      }.to change(MentorTeacher, :count).by(-1)
    end

    it "redirects to the mentor_teachers list" do
      mentor_teacher = create_mentor_teacher
      delete :destroy, {:id => mentor_teacher.to_param}, valid_session
      response.should redirect_to(mentor_teachers_url)
    end
  end

end
