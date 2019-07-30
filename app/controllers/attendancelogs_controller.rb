class AttendancelogsController < ApplicationController
  def create
  end
  
  def index
    @attendancelogs = Attendancelog.where(user_id: params[:user_id]).order(:attendance_date)
  end
  
  def show
  end
end
