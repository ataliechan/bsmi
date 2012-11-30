Given /I am signed in as a student advisor and have students and teachers in system/ do
    user = User.new({:first_name => 'Sangyoon',
    :last_name => 'Park',
    :street_address => '346 soda UC Berkeley',
    :city => 'Berkeley',
    :state => 'CA',
    :zipcode => '94000',
    :phone_number => '123-456-7890',
    :email => 'myemail@nowhere.com',
    :password => '1234',
    :password_confirmation => '1234'})
    
    owner = User.build_owner("Advisor")
    user.owner = owner
    user.save!
    owner.save!
    
    user = User.new({:first_name => 'Andrew',
    :last_name => 'Mains',
    :street_address => 'blah',
    :city => 'Berkeley',
    :state => 'CA',
    :zipcode => '94000',
    :phone_number => '123-456-7890',
    :email => 'andrew@berkeley.edu',
    :password => '1234',
    :password_confirmation => '1234'})
    
    owner = User.build_owner("Student")
    user.owner = owner
    user.save!
    owner.save!
    
    
    user = User.new({:first_name => 'Orion',
    :last_name => 'Allen',
    :street_address => '346 soda UC Berkeley',
    :city => 'Berkeley',
    :state => 'CA',
    :zipcode => '94000',
    :phone_number => '123-456-7890',
    :email => 'orion@berkeley.edu',
    :password => '1234',
    :password_confirmation => '1234'})
    
    owner = User.build_owner("Student")
    user.owner = owner
    user.save!
    owner.save!
    
    user = User.new({:first_name => 'Alex',
    :last_name => 'Tom',
    :street_address => '346 soda UC Berkeley',
    :city => 'Berkeley',
    :state => 'CA',
    :zipcode => '94000',
    :phone_number => '123-456-7890',
    :email => 'alex@berkeley.edu',
    :password => '1234',
    :password_confirmation => '1234'})
    
    owner = User.build_owner("MentorTeacher")
    user.owner = owner
    user.save!
    owner.save!
    
    user = User.new({:first_name => 'Tony',
    :last_name => 'Adam',
    :street_address => '346 soda UC Berkeley',
    :city => 'Berkeley',
    :state => 'CA',
    :zipcode => '94000',
    :phone_number => '123-456-7890',
    :email => 'tony@berkeley.edu',
    :password => '1234',
    :password_confirmation => '1234'})
    
    owner = User.build_owner("MentorTeacher")
    user.owner = owner
    user.save!
    owner.save!
    
end

# --- Cal Course

Given /^(?:|I )am in the CalCourse (\w+) (?:(\d+) )page$/ do |page_name, number|
  root_page =  '/cal_courses/'+ number.to_s  + "/" 
  case page_name
    when /^show/
      visit root_page
    when /^edit/
      visit root_page + page_name
  end
end

Given /^(?:|I )am in the CalCourse (\w+) page$/ do |page_name|
  case page_name
    when /^index$/
      visit '/cal_courses'
    when /^new$/
      visit '/cal_courses/new'
    when /^edit$/
      visit '/cal_courses/2/edit'
  end
end

# --- Structure

Given /the following cal course exist/ do |tb|
  tb.hashes.each do |t|
    CalCourse.create!(t)
  end
end

Given /the following timeslots exist/ do |tb|
  tb.hashes.each do |t|
    if t.has_key?('mentor_teacher')
      t['mentor_teacher'] = MentorTeacher.joins(:user).where("users.first_name" => t['mentor_teacher']).first
      if t['mentor_teacher'].nil?
        raise NullPointerException
      end
    end
    if t.has_key?('day')
      t['day'] = t['day'].to_sym
    end

    if t.has_key?('course')
      t['course'] = Course.find_by_name(t['course'])
    end
  Timeslot.create!(t)
  end
end

Given /the following preferences exist/ do |tb|
  tb.hashes.each do |t|
  	Preference.create!(t)
  end
end


Given /the following courses exist/ do |tb|
  tb.hashes.each do |t|
    Course.create!(t)
  end
end


Given /the following districts exist/ do |tb|
  tb.hashes.each do |t|
  	District.create!(t)
  end
end

Given /the following schools exist/ do |tb|
  tb.hashes.each do |t|
    t['district'] = District.find_by_name(t['district'])
  	School.create!(t)
  end
end

Given /the following semesters exist/ do |tb|
  tb.hashes.each do |t|
    if not t['start_date']
      t['start_date'] = Date.today - 10
    end
    if not t['end_date']
      t['end_date'] = Date.today + 10
    end
    if not t['registration_deadline_id']
      d = Deadline.create!(:due_date => DateTime.now + 10)
      t['registration_deadline_id'] = d.id
    end
  	Semester.create!(t)
  end
end

Given /the following assignments exist/ do |tb|
  tb.hashes.each do |t|
    student = User.find(t['user_id']).owner
    student.placements << Timeslot.find(t['timeslot_id'])
    student.save!
  end
end

# -- Scheduleing
include MentorTeacher::SchedulesHelper
When /^I add the following timeslots on (.*?):$/ do |day ,table|

  cal_events = table.hashes.map {|h| FactoryGirl.build(:cal_event_hash, h) }
  cal_events.each do |event_hash|
    event_hash = Hash[event_hash.each_pair.map {|k, v| [k.to_s, v]}]
    script = %Q{
var event = #{dump_event(event_hash)};
 eventNewCallback(event, null);
}

    page.execute_script(script)
    
    # within("#event_edit_container") do
    #   fill_in("Start time", :with => split_time(h["start_time"]))
    # end
    click_button('save')
  end
end
  

def extract_time(time_key, timeslot_hash)
  time = split_time(timeslot_hash[time_key])
  timeslot_hash["timeslots[][#{time_key}][hour]"] = time[:hour]
  timeslot_hash["timeslots[][#{time_key}][minute]"] = time[:minute]
  timeslot_hash.delete(time_key)
end
def split_time(time_str)
  time = Time.parse(time_str)
  {:hour => time.strftime("%I %p"), 
    :minute => time.min}
end


Then /^my schedule should look like:$/ do |table|
  
end

# --- Users

Given /the following mentor teachers exist/ do |tb|
  tb.hashes.each do |t|
    user = User.new({
      :first_name => t['first_name'],
      :last_name => t['last_name'],
      :street_address => t['address'],
      :phone_number => t['phone_number'],
      :email => t['email'],
      :password => '1234',
      :password_confirmation => '1234'
    })
    owner = User.build_owner("MentorTeacher")
    owner.school = School.find_by_name!(t['school'])
    owner.save!
    user.owner = owner
    user.save!
  end
end


require 'time'

Given /^I am a mentor teacher$/ do
  password = "test"
  teacher = FactoryGirl.create(:mentor_teacher)
  user = FactoryGirl.create(:user,  
                            :password => password,
                            :owner => teacher
                            )             
  login(user.email, password)
end

Given /the following student exist/ do |tb|
  tb.hashes.each do |t|
    if t[:cal_courses]
      cal_course = CalCourse.find(t[:cal_courses.to_s])
      t.delete(:cal_courses.to_s)
  	  student = Student.new(t)
      student.cal_courses << cal_course
      student.save!
    else
  	  Student.create!(t)
    end
  end
end

Given /the following users exist/ do |tb|
  tb.hashes.each do |t|
    user = User.new({
                :first_name => t[:first_name],
                :last_name => t[:last_name],
                :street_address => '346 soda UC Berkeley',
                :city => 'Berkeley',
                :state => 'CA',
                :zipcode => '94000',
                :phone_number => '123-456-7890',
                :email => t[:email],
                :password => '1234',
                :password_confirmation => '1234'})
    owner = User.build_owner(t[:type])

    if t[:id]
      user.id = t[:id]
    end

    
    if (t[:type] != "MentorTeacher") and t[:cal_courses]
      cal_course = CalCourse.find(t[:cal_courses.to_s])
      owner.cal_courses << cal_course
    end

    if t[:type] == "MentorTeacher"
      if t['school']
        owner.school = School.find_by_name!(t['school'])
      end
    end

    user.owner = owner
    user.save!
    owner.save!
  end
end

Given /I am signed up as a student advisor/ do
  user = User.new({:first_name => 'Sangyoon',
                :last_name => 'Park',
                :street_address => '346 soda UC Berkeley',
                :city => 'Berkeley',
                :state => 'CA',
                :zipcode => '94000',
                :phone_number => '123-456-7890',
                :email => 'myemail@nowhere.com',
                :password => '1234',
                :password_confirmation => '1234'})

  owner = User.build_owner("Advisor")
  user.owner = owner
  user.save!
  owner.save!
end

Given /the following invites exist/ do |tb|
  tb.hashes.each do |t|
  	Invite.create!(t)
  end
end


Given /I am logged in as (.*)/ do |email| 
  user = User.find_by_email(email)
  login(email, '1234')
end


Given /I am invited and on the signup page/ do
  visit "/signup?owner_type=Student&invite_code=aa10df161da4c011d507dea384aa2d03cbc2e5ba"
end

Given /we are currently in a semester/ do
  Semester.create!(
    :name => Semester::FALL, 
    :year => "2012", 
    :start_date => Date.today - 10, 
    :end_date => Date.today + 10,
    :registration_deadline => Deadline.new(
      :title => "Registraiton Deadline",
      :summary => "You must have you preferences selected by this deadline",
      :due_date => Date.new(2012, 1, 16),
    ),
    :status => Semester::PUBLIC,
  )
end


def login(email, password)
  visit '/login'
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
  page.should have_content('Login successful')
end 


# --- Helpers
Then /^(?:|I )should be located at "([^"]*)"$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == page_name
  else
    assert_equal page_name, current_path
  end
end


When /^I click element containing "([^\"]+)"$/ do |text|
  matcher = ['*', { :text => text }]
  element = page.find(:css, *matcher)
  while better_match = element.first(:css, *matcher)
    element = better_match
  end
  element.click
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  page.body.should match /#{e1}.*?#{e2}/m
end

