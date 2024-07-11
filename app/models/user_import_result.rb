class UserImportResult
  attr_reader :results, :status

  class << self
    def determine_status(results)
      # TODO: determine status based on the status of results
    end
  end

  def initialize(results:, status:)
    @results = results # array of UserResults
    @status = status
  end
end
