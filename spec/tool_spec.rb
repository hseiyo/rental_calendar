# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tool do
  describe "#create" do
    context "normal case" do
      let(:tool_info) { { tooltype: 1, toolname: "tooltest1", toolvalid: true } }

      it "can create a user" do
        Tool.find_by(toolname: "tooltest1" )&.destroy
        expect(Tool.create(tool_info).toolname).to eq tool_info[:toolname]
        Tool.find_by(toolname: "tooltest1" )&.destroy
      end
    end
    context "with invalid arguments" do
      let(:twice_info) { { tooltype: 1, toolname: "tooltest2", toolvalid: true } }
      it "does'nt create with error" do

        # clear test record
        Tool.find_by(toolname: "tooltest2" )&.destroy

        expect { Tool.create(1, 2) }.to raise_error(ArgumentError)
        expect { Tool.create(user_name: "username") }.to raise_error(NameError)

        newtool = Tool.create(twice_info)
        newtool.valid?

        expect(newtool.errors.messages.empty?).to eq true
        expect(Tool.new(twice_info).valid?).to eq false
        expect(newtool.destroy ).not_to eq nil
      end
    end
  end
end
