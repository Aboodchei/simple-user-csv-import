class UsersController < ApplicationController
  require "csv"

  def index
  end

  def import
    file = params[:file]
    @result = UserImportService.call(file: file)
    respond_to do |format|
      format.turbo_stream
    end
  end
end
