class UserImportResult
  attr_reader :results, :status

  class << self
    def determine_status(results)
      if results.any? { |result| result.status == ImportStatus::INVALID_CSV_ROW }
        ImportStatus::INVALID_CSV_ROW
      elsif results.all? { |result| result.status == ImportStatus::SUCCESS }
        ImportStatus::SUCCESS
      elsif results.none? { |result| result.status == ImportStatus::SUCCESS }
        ImportStatus::FAILURE
      else
        ImportStatus::PARTIAL_SUCCESS
      end
    end
  end

  def initialize(results: [], status:)
    @results = results # array of UserResults
    @status = status
  end

  def description
    ImportStatus::IMPORT_MESSAGES[status]
  end
end
