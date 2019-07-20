class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_attendances
    @attendances = Attendance.where(superior_id: params[:id], status_id: 2).order(:user_id, :worked_on)
    @users = User.all
  end
  
  def update_attendances
    
  end

  def edit_one_month
  end
  
  def update_one_month
    dates_on = []
    ActiveRecord::Base.transaction do # トランザクションを開始します
      attendances_params.each do |id, item|
        if item[:superior_id].present? 
          attendance = Attendance.find(id)
          if item[:next_day] == '1'
            item[:finished_at] = item[:finished_at].in_time_zone + 1.days
          end
          attendance.update_attributes!(item)
        elsif item[:started_at].present? || item[:finished_at].present? || item[:note].present?
          dates_on.push(l(Attendance.find(id).worked_on, format: :short))
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    if dates_on.count > 0
      flash[:danger] = "#{dates_on.join(', ')}の上長を選択してください。"
    end
    redirect_to user_url(date: params[:date])
    
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :next_day, :note, :superior_id])[:attendances]
    end
end
