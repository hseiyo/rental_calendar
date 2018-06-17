# frozen_string_literal: true

# require "spec_helper"
require_relative "../app/calendar.rb"

RSpec.describe User do
  describe "#create" do
    context "normal case" do
      let(:user_info) { { username: "test_user1" } }

      it "can create a user" do
        expect(User.create(user_info).username).to eq user_info[:username]
      end
    end
    context "with invalid arguments" do
      it "does'nt create with error" do
        expect { User.create(1, 2) }.to raise_error(ArgumentError)
        expect { User.create(user_name: "username") }.to raise_error(NameError)
      end
    end
  end
end
