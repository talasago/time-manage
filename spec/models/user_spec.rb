require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {User.new(name: "TestUser", password: "foobarbaz", password_confirmation: "foobarbaz") }

  #パスワードの前置後置空白

  ##validationテスト（正常系）
  #describe "is be valid" do
  #  it { expect(user).to be_valid }
#
  #  describe "password_disest password different" do
  #    before { user.save }
  #    let(:found_user) { User.find_by(name: user.name) }
  #    it { expect(found_user.password_disest).not_to eq(user.password) }
  #  end
  #end

  #validationテスト（異常系）
  it "name nil" do
    user.name = nil
    expect(user).not_to be_valid
  end

  it "name space" do
    user.name = "    "
    expect(user).not_to be_valid
  end

  it "name too long" do
    user.name = "a" * 51
    expect(user).not_to be_valid
  end

  it "name non-alphanumeric(symbol)" do
    user.name = "Te!st"
    expect(user).not_to be_valid
  end

  it "non-alphanumeric(japanese)" do
    user.name = "Test日本語"
    expect(user).not_to be_valid
  end

  it "non-alphanumeric(Postfix space)" do
    user.name = "Test "
    expect(user).not_to be_valid
  end

  it "non-alphanumeric(Preface space)" do
    user.name = " Test"
    expect(user).not_to be_valid
  end

  it "non-alphanumeric(in word)" do
    user.name = "Test User"
    expect(user).not_to be_valid
  end

  #nameの一意性


  #it "password nil" do
  #  user.password = user.password_confirmation = nil
  #  expect(user).not_to be_valid
  #end
#
  #it "password space" do
  #  user.password = user.password_confirmation = " " * 8
  #  expect(user).not_to be_valid
  #end
#
  #it "password too short" do
  #  user.password = user.password_confirmation = "a" * 7
  #  expect(user).not_to be_valid
  #end
#
  #it "password mismatch confirmation" do
  #  user.password_confirmation = "foobar"
  #  expect(user).not_to be_valid
  #end
#
  #describe "return value of authenticate()" do
  #  before { user.save }
  #  let(:found_user) { User.find_by(name: user.name) }
#
  #  context "when valid password" do
  #    it { expect(found_user.authenticate(user.password)).to true }
  #  end
#
  #  context "when invalid password" do
  #    it { expect(found_user.authenticate("invalidpassword")).to false }
  #  end
  #end
end
