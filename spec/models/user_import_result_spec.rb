require 'rails_helper'

RSpec.describe UserImportResult, type: :model do
  describe '#description' do
    ImportStatus::IMPORT_MESSAGES.each do |status, message|
      it "returns the correct description for status #{status}" do
        result = UserImportResult.new(results: [], status: status)
        expect(result.description).to eq(message)
      end
    end
  end
end
