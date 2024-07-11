class UserImportService
  require "csv"

  class << self
    def call(file:)
      return UserImportResult.new(status: ImportStatus::EMPTY_FILE) if file.blank?

      csv_content = file.read
      return UserImportResult.new(status: ImportStatus::EMPTY_FILE) if csv_content.blank?

      parsed_csv = CSV.parse(csv_content, headers: true)
      return UserImportResult.new(status: ImportStatus::INVALID_CSV_HEADER) unless valid_headers?(parsed_csv.headers)

      results = []

      ActiveRecord::Base.transaction do
        parsed_csv.each_with_index do |row, index|
          row_number = index + 1
          if valid_row?(row)
            results << create_user(row, row_number)
          else
            results << UserResult.new(**user_result_attributes(row, row_number, ImportStatus::INVALID_CSV_ROW))
          end
        end

        status = UserImportResult.determine_status(results)
        if status == ImportStatus::INVALID_CSV_ROW
          # filter out successful results since we are rolling back, and only show failures + invalid rows
          results = results.select { |r| r.status != ImportStatus::SUCCESS }
          raise ActiveRecord::Rollback
        end
      end

      status = UserImportResult.determine_status(results)
      UserImportResult.new(results: results, status: status)
    end

    private

    def valid_headers?(headers)
      headers == [ "name", "password" ]
    end

    def valid_row?(row)
      row["name"].present? && row["password"].present? && row.to_h.keys.count == 2
    end

    def create_user(row, row_number)
      user = User.new(user_attributes(row))
      if user.save
        UserResult.new(**user_result_attributes(row, row_number, ImportStatus::SUCCESS))
      else
        UserResult.new(**user_result_attributes(row, row_number, ImportStatus::FAILURE, user.errors.full_messages))
      end
    end

    def user_attributes(row)
      {
        name: row["name"],
        password: row["password"]
      }
    end

    def user_result_attributes(row, row_number, status, errors = [])
      user_attributes(row).merge(
        row: row_number,
        status: status,
        errors: errors
      )
    end
  end
end
