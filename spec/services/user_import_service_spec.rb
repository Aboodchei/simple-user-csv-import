# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserImportService, type: :service do
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures", file_path), "text/csv") }
  let(:result) { UserImportService.call(file: file) }

  describe '.call' do
    context 'with a valid CSV file (with users)' do
      let(:file_path) { 'valid_users.csv' }

      it 'returns a UserImportResult with success status' do
        expect { result }.to change { User.count }.by(2)
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::SUCCESS)
        expect(result.results.size).to eq(2)
        expect(result.results.map(&:status).uniq).to eq([ ImportStatus::SUCCESS ])
        expect(result.results.map(&:row)).to eq([ 1, 2 ])
      end

      it 'correctly saves user info' do
        result
        user = User.last
        expect(user.name).to eq('Jane Smith')
        expect(user.authenticate("Password456")).to be_truthy
      end
    end

    context 'with a valid CSV file (no users)' do
      let(:file_path) { 'no_users.csv' }

      it 'returns a UserImportResult with success status' do
        expect { result }.to change { User.count }.by(0)
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::SUCCESS)
        expect(result.results.size).to eq(0)
      end
    end

    context 'with an empty CSV file' do
      let(:file_path) { 'empty.csv' }

      it 'returns a UserImportResult with empty file status and no results' do
        expect { result }.not_to change { User.count }
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::EMPTY_FILE)
        expect(result.results).to be_empty
      end
    end

    context 'with a CSV file with wrong header' do
      let(:file_path) { 'invalid_header.csv' }

      it 'returns a UserImportResult with invalid CSV header status and no changes to user count' do
        expect { result }.not_to change { User.count }
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::INVALID_CSV_HEADER)
        expect(result.results).to be_empty
      end
    end

    context 'with a CSV file with wrong row (additional column)' do
      let(:file_path) { 'invalid_row_1.csv' }

      it 'returns a UserImportResult with invalid CSV row status and no changes to user count' do
        expect { result }.not_to change { User.count }
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
        expect(result.results.size).to eq(1)
        expect(result.results.first.status).to eq(ImportStatus::INVALID_CSV_ROW)
        expect(result.results.map(&:row)).to eq([ 2 ])
      end
    end

    context 'with a CSV file with wrong row (missing column)' do
      let(:file_path) { 'invalid_row_2.csv' }

      it 'returns a UserImportResult with invalid CSV row status and no changes to user count' do
        expect { result }.not_to change { User.count }
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
        expect(result.results.size).to eq(1)
        expect(result.results.first.status).to eq(ImportStatus::INVALID_CSV_ROW)
        expect(result.results.map(&:row)).to eq([ 2 ])
      end
    end

    context 'with a CSV file with multiple invalid rows' do
      let(:file_path) { 'invalid_row_3.csv' }

      it 'returns a UserImportResult with invalid and failed CSV row status and no user creation' do
        expect { result }.not_to change { User.count }
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
        expect(result.results.size).to eq(3)
        expect(result.results.map(&:status)).to eq([ ImportStatus::INVALID_CSV_ROW, ImportStatus::FAILURE, ImportStatus::INVALID_CSV_ROW ])
        expect(result.results.map(&:row)).to eq([ 2, 3, 4 ])
      end
    end

    context 'with a CSV file with a password strength failure (partial)' do
      let(:file_path) { 'partially_failing_users.csv' }

      it 'returns a UserImportResult with partial success status and partial user creation' do
        expect { result }.to change { User.count }.by(1)
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::PARTIAL_SUCCESS)
        expect(result.results.size).to eq(2)
        expect(result.results.map(&:status)).to eq([ ImportStatus::FAILURE, ImportStatus::SUCCESS ])
        expect(result.results.map(&:row)).to eq([ 1, 2 ])
      end
    end

    context 'with a CSV file with a password strength failure (full)' do
      let(:file_path) { 'failing_users.csv' }

      it 'returns a UserImportResult with failure status and no user creation' do
        expect { result }.to change { User.count }.by(0)
        expect(result).to be_a(UserImportResult)
        expect(result.status).to eq(ImportStatus::FAILURE)
        expect(result.results.size).to eq(2)
        expect(result.results.map(&:status).uniq).to eq([ ImportStatus::FAILURE ])
        expect(result.results.map(&:row)).to eq([ 1, 2 ])
        expect(result.results.map(&:errors).flatten).to be_truthy
      end
    end
  end
end
