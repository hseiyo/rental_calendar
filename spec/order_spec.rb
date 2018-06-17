# frozen_string_literal: true

# require "spec_helper"
require_relative "../app/calendar.rb"

RSpec.describe Order do
  describe "#create" do
    context "normal case" do
      let(:user_info) { { username: "test_user1" } }
      let(:reservation_info) { [{ tool_id: 1, begin: Date.today, finish: Date.today }] }

      it "create order" do
        expect(Order.create(user_info, reservation_info).username).to eq user_info[:username]
      end
    end
    context "error case" do
      it "does'nt create with error" do
        expect { Order.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end
end
