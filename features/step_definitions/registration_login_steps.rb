Given /the following user exist/ do |tb|
  tb.hashes.each do |t|
  	User.create!(t)
  end
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

Given /the following users exists/ do |tb|
  tb.hashes.each do |t|
    user = User.new({:name => t[:name],
                :address => '346 soda UC Berkeley, United States',
                :phone_number => '123-456-7890',
                :email => t[:email],
                :password => t[:pass],
                :password_confirmation => t[:pass]})
    owner = User.build_owner(t[:type])
    user.owner = owner
    user.save
    owner.save
  end
end

Given /the following invites exist/ do |tb|
  tb.hashes.each do |t|
  	Invite.create!(t)
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
  user.save
  owner.save
end


Given /I am invited and on the signup page/ do
  visit "/signup?owner_type=Student&invite_code=aa10df161da4c011d507dea384aa2d03cbc2e5ba"
end


def login(email, password)
  visit '/login'
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
  page.should have_content('Login successful')
end 


Then /^(?:|I )should be located at "([^"]*)"$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == page_name
  else
    assert_equal page_name, current_path
  end
end
