require 'spec_helper'

describe List do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:list) {FactoryGirl.build :list}
  subject { list }

  it { should respond_to(:item) }
  it { should respond_to(:user_id) }
  it { should belong_to :user }
end
