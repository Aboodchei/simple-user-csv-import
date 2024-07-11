class UserResult
  attr_reader :name, :password, :row, :status, :errors

  def initialize(name:, password:, row:, status:, errors: [])
    @name = name
    @password = password
    @row = row
    @status = status
    @errors = errors
  end

  def description
    ImportStatus::USER_MESSAGES[status]
  end
end
