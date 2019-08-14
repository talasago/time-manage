require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(
      name: "TestUser001",
      password: "foobarbaz",
      password_confirmation: "foobarbaz"
    )
  end
  subject { @user }

  it "is be valid" do
    expect(@user).to be_valid
  end

  describe "name" do
    describe "invaild" do
      it "name nil" do
        @user.name = nil
        expect(@user).not_to be_valid
      end

      it "name space" do
        @user.name = "    "
        expect(@user).not_to be_valid
      end

      it "name too long" do
        @user.name = "a" * 51
        expect(@user).not_to be_valid
      end

      it "name non-alphanumeric(symbol)" do
        @user.name = "Te!st"
        expect(@user).not_to be_valid
      end

      it "non-alphanumeric(japanese)" do
        @user.name = "Test日本語"
        expect(@user).not_to be_valid
      end

      it "non-alphanumeric(Postfix space)" do
        @user.name = "Test "
        expect(@user).not_to be_valid
      end

      it "non-alphanumeric(Preface space)" do
        @user.name = " Test"
        expect(@user).not_to be_valid
      end

      it "non-alphanumeric(in word)" do
        @user.name = "Test User"
        expect(@user).not_to be_valid
      end

      it "non-alphanumeric(in word)" do
        @user.name = "ＴｅｓｔＵｓｅｒ００１"
        expect(@user).not_to be_valid
      end

      it "name already exist" do
        duplicate_user = @user.dup
        @user.save
        expect(duplicate_user).not_to be_valid
      end
    end
  end

  describe "password" do
    describe "invalid" do
      it "password nil" do
        @user.password = @user.password_confirmation = nil
        expect(@user).not_to be_valid
      end

      it "password space" do
        @user.password = @user.password_confirmation = " " * 8
        expect(@user).not_to be_valid
      end

      it "password too short" do
        @user.password = @user.password_confirmation = "a" * 7
        expect(@user).not_to be_valid
      end

      it "password mismatch confirmation" do
        @user.password_confirmation = "foobar"
        expect(@user).not_to be_valid
      end
    end

    describe "return value of authenticate()" do
      before { @user.save }
      let(:found_user) { User.find_by(name: @user.name) }

      context "when valid password" do
        it "authenticate true and password_digest password difference" do
          expect(found_user.authenticate(@user.password)).to be_truthy
          expect(found_user.password_digest).not_to eq(@user.password)
        end
      end

      context "when invalid password" do
        it { expect(found_user.authenticate("invalidpassword")).to be_falsey }
      end
    end
  end
end
