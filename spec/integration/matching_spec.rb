require 'spec_helper'



describe "The matching solution" do

  before(:each) do
    @solver = MatchingSolver.new(preferences)
  end

  shared_examples_for "a good matching:" do
    
    let(:students) { Set.new(preferences.map {|p| p.student_id}) }
    let(:timeslots) { Set.new(preferences.map {|p| p.timeslot_id}) }

    it "should match every student to exactly one timeslot" do
      counts = Hash.new(0) 
      subject.each do |pref|
        counts[pref.student_id] += 1
      end
      students.each do |s|
        counts[s].should eq(1), "Student #{s} wasn't matched"
      end
    end

    it "should match every timeslot to exactly one student" do
      counts = Hash.new(0) 
      subject.each do |pref|
        counts[pref.timeslot_id] += 1
      end
      timeslots.each do |t|
        counts[t].should eq(1), "Timeslot #{t} wasn't matched"
      end
    end


    it "should have the correct matching score" do
      subject.map {|p| p.ranking}.reduce(:+).should eq(desired_matching_score)
    end

  end

  subject { @solver.solve }
  context "in a simple example" do
    let(:preferences) do
      build_preferences(:s1 => [[:t1, 1], [:t2, 2]],
                        :s2 => [[:t1, 1]],
                        :s3 => [[:t2, 1], [:t3, 2]])      
    end
    let(:desired_matching_score) { 5 }
    
    it_behaves_like "a good matching:"
  end

  context "when everyone has the same preferences" do
    let(:preferences) do
      build_preferences(:s1 => [[:t1, 1], [:t2, 2], [:t3, 3]],
                        :s2 => [[:t1, 1], [:t2, 2], [:t3, 3]],
                        :s3 => [[:t1, 1], [:t2, 2], [:t3, 3]])
    end
    let(:desired_matching_score) { 6 }
    
    it_behaves_like "a good matching:"
  end

  context "when everyone has a different first choice" do
    let(:preferences) do
      build_preferences(:s1 => [[:t1, 1], [:t2, 2]],
                        :s2 => [[:t2, 1], [:t2, 2]],
                        :s3 => [[:t3, 1], [:t2, 2]])
    end
    let(:desired_matching_score) { 3 }
    
    it_behaves_like "a good matching:"
  end



##################################################
# Helpers
##################################################

  # Construct a list of preferences from preference_hash
  #
  #preference_hash: Hash mapping students to lists of timeslot-ranking pairs.
  #Both students and timeslots can be represented by anything ending in a number--i.e
  # :t1, "t1" and 1 are all valid (the id for the timeslot is taken off the end).
  #
  # Sample use:       
  #     build_preferences(:s1 => [[:t1, 1], [:t2, 2]],
  #                       :s2 => [[:t2, 1], [:t2, 2]],
  #                       :s3 => [[:t3, 1], [:t2, 2]])

  def build_preferences(preference_hash) 
    prefs = []

    def extract_id(thing)
      id_pattern = /.*?(\d+)$/
      thing = thing.to_s
      match = id_pattern.match(thing)
      if match
        return match[1].to_i
      else
        throw ArgumentError.new("Can't extract an id from #{thing}; needs a number at the end")
      end
    end
    
    preference_hash.each_pair do |student, ts_ranking_pairs|
      ts_ranking_pairs.each do |pair|
        timeslot, ranking = pair        
        prefs << FactoryGirl.build_stubbed(:preference,
                                           :student_id => extract_id(student),
                                           :timeslot_id => extract_id(timeslot),
                                           :ranking => ranking)
      end
    end
    return prefs
  end


end
