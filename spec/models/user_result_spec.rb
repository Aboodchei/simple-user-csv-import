require 'rails_helper'

RSpec.describe UserResult, type: :model do
  describe '#description' do
    ImportStatus::USER_MESSAGES.each do |status, message|
      it "returns the correct description for status #{status}" do
        result = UserResult.new(name: "Test User", password: "password", row: 1, status: status)
        expect(result.description).to eq(message)
      end
    end
  end
end
