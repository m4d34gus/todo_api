require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should have_many(:lists) }

  it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email) }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('made@made.com').for(:email) }

  it { should be_valid }

  describe "#todo association" do
    before do
      @user.save
      3.times { FactoryGirl.create :list, user: @user }
    end

    it "destroys the assocated lists n self distruct" do
      lists = @user.lists
      @user.destroy
      lists.each do |list|
        expect(List.find(list)).to raise_error ActiveRecord::RecordNotFoud
      end
    end
  end
end
