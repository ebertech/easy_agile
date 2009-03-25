require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StoryTeamMember do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :story_id => 1
    }
  end

  describe "protection" do
    it "should not allow mass-assignment of user_id" do
      member = StoryTeamMember.new :user_id => 22
      member.user_id.should be_blank
    end
  end

  describe "associations" do
    it "should belong to a user" do
      StoryTeamMember.should belong_to(:user)
    end

    it "should belong to a story" do
      StoryTeamMember.should belong_to(:story)
    end
  end

  describe "validations" do
    before :each do
      @story_team_member = StoryTeamMember.new
      @story_team_member.valid?
    end

    it "should require a user" do
      @story_team_member.should have(1).error_on(:user_id)
    end

    it "should require a story" do
      @story_team_member.should have(1).error_on(:story_id)
    end

    it "should require that story and user are a unique combination" do
      user = Users.create_user
      story = Stories.create_story
      @story_team_member.user = user
      @story_team_member.story = story
      @story_team_member.save!
      lambda {StoryTeamMember.create!(:user => user, :story => story)}.
        should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require that the user belongs to organisation of the story's project"
  end
end
