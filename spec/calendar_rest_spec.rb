# frozen_string_literal: true

# require "spec_helper"
require_relative "../app/calendar_rest.rb"
require "rack/test"

def app
  Sinatra::Application
end

RSpec.describe "rest for admin" do
  include Rack::Test::Methods

  describe "tools" do
    context "by get" do
      context "with valid" do
        it "doesn't nil" do
          get "/admin/tools/?"
          expect(last_response.body).not_to eq nil
          expect(last_response.body.length).to be > 0

          responseobj = JSON.parse(last_response.body)
          expect(responseobj[0].key?("id")).to be_truthy
          expect(responseobj[0].key?("tooltype")).to be_truthy
          expect(responseobj[0].key?("toolname")).to be_truthy
          expect(responseobj[0].key?("toolvalid")).to be_truthy
        end
      end
    end
  end
end

RSpec.describe Calendar do
  describe "#get_date_info" do
    # reserve_info = {}
    # reserve_info[:year] = params["year"].to_i
    # reserve_info[:month] = params["month"].to_i
    # reserve_info[:day] = params["day"].to_i
    # reserve_info[:needdays] = params["days"].to_i
    # reserve_info[:tooltype] = params["tooltype"].to_i
    # reserve_info[:username] = params["username"]
    # reserve_info[:phone] = params["phone"]
    # reserve_info[:email] = params["email"]
    # reserve_info[:address] = params["address"]
    # reserve_info[:toolop] = []
    # reserve_info[:toolop].push(params["toolop1"]) if params.key?(:toolop1)
    # reserve_info[:toolop].push(params["toolop2"]) if params.key?(:toolop2)
    # reserve_info[:toolop].push(params["toolop3"]) if params.key?(:toolop3)

    describe "year argument" do
      let(:info) { { year: year, month: 1, day: 1, needdays: 1 } }
      context "with valid" do
        let(:year) { 2019 }
        it "doesn't return error" do
          expect(Calendar.get_date_info(info)).not_to eq nil
        end
      end
      context "with invalid year" do
        context "as stringr" do
          let(:year) { "2019" }
          it "as string returns error" do
            expect(Calendar.get_date_info(info)).to eq nil
          end
        end
        context "lessr" do
          let(:year) { 2017 }
          it "is less returns error" do
            expect(Calendar.get_date_info(info)).to eq nil
          end
        end
      end
    end
    describe "month argument" do
      let(:info) { { year: 2020, month: month, day: 1, needdays: 1 } }
      context "with valid" do
        let(:month) { 1 }
        it "doesn't return error" do
          expect(Calendar.get_date_info(info)).not_to eq nil
        end
      end
      context "with invalid" do
        context "as string" do
          let(:month) { "1" }
          it "as string returns error" do
            expect(Calendar.get_date_info(info)).to eq nil
          end
        end
        context "less" do
          let(:month) { 0 }
          it "is less returns error" do
            expect(Calendar.get_date_info(info)).to eq nil
          end
        end
        context "greater" do
          let(:month) { 13 }
          it "is greater returns error" do
            expect(Calendar.get_date_info(info)).to eq nil
          end
        end
      end
    end
  end
end
