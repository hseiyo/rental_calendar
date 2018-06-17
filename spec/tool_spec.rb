# frozen_string_literal: true

# require "spec_helper"
require_relative "../app/calendar.rb"

RSpec.describe Tool do
  describe "#create" do
    context "normal case" do
      let(:tool_info) { { tooltype: 1, toolname: "tool1", toolvalid: true } }

      it "can create a user" do
        expect(Tool.create(tool_info).toolname).to eq tool_info[:toolname]
      end
    end
    context "with invalid arguments" do
      let(:twice_info) { { tooltype: 1, toolname: "tool2", toolvalid: true } }
      it "does'nt create with error" do
        expect { Tool.create(1, 2) }.to raise_error(ArgumentError)
        expect { Tool.create(user_name: "username") }.to raise_error(NameError)
        expect { Tool.create(twice_info).valid? }.to eq true
        expect { Tool.new(twice_info).valid? }.to eq false
      end
    end
  end
end
