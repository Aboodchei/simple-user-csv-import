# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserImportService, type: :service do
  let(:valid_users_file) { fixture_file_upload(Rails.root.join('spec/fixtures/valid_users.csv'), 'text/csv') }
  let(:no_users_file) { fixture_file_upload(Rails.root.join('spec/fixtures/no_users.csv'), 'text/csv') }
  let(:empty_file) { fixture_file_upload(Rails.root.join('spec/fixtures/empty.csv'), 'text/csv') }
  let(:invalid_header_file) { fixture_file_upload(Rails.root.join('spec/fixtures/invalid_header.csv'), 'text/csv') }
  let(:invalid_row_file_1) { fixture_file_upload(Rails.root.join('spec/fixtures/invalid_row_1.csv'), 'text/csv') }
  let(:invalid_row_file_2) { fixture_file_upload(Rails.root.join('spec/fixtures/invalid_row_2.csv'), 'text/csv') }
  let(:invalid_row_file_3) { fixture_file_upload(Rails.root.join('spec/fixtures/invalid_row_3.csv'), 'text/csv') }
  let(:partially_failing_users_file) { fixture_file_upload(Rails.root.join('spec/fixtures/partially_failing_users.csv'), 'text/csv') }
  let(:failing_users_file) { fixture_file_upload(Rails.root.join('spec/fixtures/failing_users.csv'), 'text/csv') }

  describe '.call' do
    context 'with a valid CSV file (with users)' do
      it 'returns a UserImportResult with success status' do
        expect {
          result = UserImportService.call(file: valid_users_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::SUCCESS)
          expect(result.results.size).to eq(2)
        }.to change { User.count }.by(2)
      end
    end

    context 'with a valid CSV file (no users)' do
      it 'returns a UserImportResult with success status' do
        expect {
          result = UserImportService.call(file: no_users_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::SUCCESS)
          expect(result.results.size).to eq(2)
        }.to change { User.count }.by(2)
      end
    end

    context 'with an empty CSV file' do
      it 'returns a UserImportResult with empty file status and no results' do
        expect {
          result = UserImportService.call(file: empty_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::EMPTY_FILE)
          expect(result.results).to be_empty
        }.not_to change { User.count }
      end
    end

    context 'with a CSV file with wrong header' do
      it 'returns a UserImportResult with invalid CSV header status and no changes to user count' do
        expect {
          result = UserImportService.call(file: invalid_header_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::INVALID_CSV_HEADER)
          expect(result.results).to be_empty
        }.not_to change { User.count }
      end
    end

    context 'with a CSV file with wrong row (additional column)' do
      it 'returns a UserImportResult with invalid CSV row status and no changes to user count' do
        expect {
          result = UserImportService.call(file: invalid_row_file_1)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
          expect(result.results.size).to eq(1)
          expect(result.results.first.status).to eq(ImportStatus::INVALID_CSV_ROW)
        }.not_to change { User.count }
      end
    end

    context 'with a CSV file with wrong row (missing column)' do
      it 'returns a UserImportResult with invalid CSV row status and no changes to user count' do
        expect {
          result = UserImportService.call(file: invalid_row_file_2)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
          expect(result.results.size).to eq(1)
          expect(result.results.first.status).to eq(ImportStatus::INVALID_CSV_ROW)
        }.not_to change { User.count }
      end
    end

    context 'with a CSV file with multiple invalid rows' do
      it 'returns a UserImportResult with invalid and failed CSV row status and no user creation' do
        expect {
          result = UserImportService.call(file: invalid_row_file_3)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::INVALID_CSV_ROW)
          expect(result.results.size).to eq(3)
          expect(result.results.count { |r| r.status == ImportStatus::INVALID_CSV_ROW }).to eq(2)
          expect(result.results.count { |r| r.status == ImportStatus::FAILURE }).to eq(1)
        }.not_to change { User.count }
      end
    end

    context 'with a CSV file with a password strength failure (partial)' do
      it 'returns a UserImportResult with partial success status and partial user creation' do
        expect {
          result = UserImportService.call(file: partially_failing_users_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::PARTIAL_SUCCESS)
          expect(result.results.size).to eq(2)
        }.to change { User.count }.by(1)
      end
    end

    context 'with a CSV file with a password strength failure (full)' do
      it 'returns a UserImportResult with failure status and no user creation' do
        expect {
          result = UserImportService.call(file: failing_users_file)
          expect(result).to be_a(UserImportResult)
          expect(result.status).to eq(ImportStatus::FAILURE)
          expect(result.results.size).to eq(2)
        }.to change { User.count }.by(0)
      end
    end
  end
end
