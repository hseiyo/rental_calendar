# frozen_string_literal: true

# require "spec_helper"
require_relative "../app/sinatra.rb"

RSpec.describe Calendar do
  describe "#get_date_info" do
    describe "year argument" do
      context "with valid" do
        it "doesn't return error" do
          expect(Calendar.get_date_info(1, 2019, 1)).not_to eq nil
        end
      end
      context "with invalid" do
        it "as string returns error" do
          expect(Calendar.get_date_info(1, "a", 1)).to eq nil
        end
        it "is less returns error" do
          expect(Calendar.get_date_info(1, 2017, 1)).to eq nil
        end
      end
    end
    describe "month argument" do
      context "with valid" do
        it "doesn't return error" do
          expect(Calendar.get_date_info(1, 2019, 1)).not_to eq nil
        end
      end
      context "with invalid" do
        it "as string returns error" do
          expect(Calendar.get_date_info(1, 2019, "1")).to eq nil
        end
        it "is less returns error" do
          expect(Calendar.get_date_info(1, 2019, 0)).to eq nil
        end
        it "is greater returns error" do
          expect(Calendar.get_date_info(1, 2019, 13)).to eq nil
        end
      end
    end
  end
end
