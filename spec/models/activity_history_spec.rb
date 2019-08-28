require 'rails_helper'

RSpec.describe ActivityHistory, type: :model do
    before do
      @act_history = FactoryBot.create(:activity_history)
    end

    it "is be valid" do
      expect(@act_history).to be_valid
    end

    describe "user_id" do
      it "user_id nil" do
        @act_history.user_id = nil
        expect(@act_history).not_to be_valid
      end

      it "user_id space" do
        @act_history.user_id = "    "
        expect(@act_history).not_to be_valid
      end
    end


    describe "activity_name" do
      it "name nil" do
        @act_history.activity_name = nil
        expect(@act_history).not_to be_valid
      end

      it "name space" do
        @act_history.activity_name = "    "
        expect(@act_history).not_to be_valid
      end

      it "name too long" do
        @act_history.activity_name = "a" * 51
        expect(@act_history).not_to be_valid
      end
    end

    describe "time" do
      context "comparison to_time, from_time" do
        it "equal" do
          @act_history.to_time = @act_history.from_time
          expect(@act_history).not_to be_valid
        end

        it "to_time > from_time" do
          @act_history.to_time = DateTime.parse("2019/08/25 10:59:59")
          expect(@act_history).not_to be_valid
        end
      end

      describe "from_time" do
        it "from_time nil" do
          @act_history.from_time = nil
          expect(@act_history).not_to be_valid
        end

        it "from_time space" do
          @act_history.from_time = "    "
          expect(@act_history).not_to be_valid
        end

        it "impossible date " do
          @act_history.from_time = "2019/13/35 15:00:00"
          expect(@act_history).not_to be_valid
        end

        it "impossible time " do
          @act_history.from_time = "2019/11/20 28:00:00"
          expect(@act_history).not_to be_valid
        end

        it "TRUE from_time leap year" do
          @act_history.from_time = "2016/2/29 15:00:15"
          expect(@act_history).to be_valid
        end
      end

      describe "to_time" do
        it "to_time nil" do
          @act_history.to_time = nil
          expect(@act_history).not_to be_valid
        end

        it "to_time space" do
          @act_history.to_time = "    "
          expect(@act_history).not_to be_valid
        end

        it "impossible date " do
          @act_history.to_time = "2019/13/35 15:00:00"
          expect(@act_history).not_to be_valid
        end

        it "impossible time " do
          @act_history.to_time = "2019/11/20 24:00:60"
          expect(@act_history).not_to be_valid
        end
      end
    end

    describe "remarks" do
      it "remarks too long" do
        @act_history.remarks = "a" * 256
        expect(@act_history).not_to be_valid
      end

      it "TRUE remarks nil" do
        @act_history.remarks = nil
        expect(@act_history).to be_valid
      end
    end

end
