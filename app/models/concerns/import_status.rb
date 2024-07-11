module ImportStatus
  SUCCESS = "Success".freeze
  PARTIAL_SUCCESS = "Partial Success".freeze
  FAILURE = "Failure".freeze
  EMPTY_FILE = "Empty File".freeze
  INVALID_CSV_HEADER = "Invalid CSV Header Format".freeze
  INVALID_CSV_ROW = "Invalid CSV Row Format".freeze

  IMPORT_MESSAGES = {
    SUCCESS => "All users in CSV imported successfully.",
    PARTIAL_SUCCESS => "Some users were imported successfully, while others failed. Please check the error messages below.",
    FAILURE => "Could not import any users. Please check the error messages below.",
    EMPTY_FILE => "CSV file empty. Please make sure there is data.",
    INVALID_CSV_HEADER => "Encounted an issue with CSV header. Please make sure it is formatted correctly. Import cancelled.",
    INVALID_CSV_ROW => "Encountered an issue with a user row. Import cancelled."
  }

  USER_MESSAGES = {
    SUCCESS => "User was created successfully.",
    FAILURE => "User creation failed.",
    INVALID_CSV_ROW => "Please make sure data is formatted correctly for this user."
  }
end
