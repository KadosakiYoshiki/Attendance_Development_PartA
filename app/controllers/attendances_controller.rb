class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :superior_or_correct_user, only: [:edit_one_month, :update_one_month]
  before_action :superior_user, only: [:edit_overtimes, :update_overtimes, :edit_attendances, :update_attendances]
  before_action :reject_admin_user, only: [:edit_one_month, :logs]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  ### 上長での残業申請処理 ###
  def edit_overtimes
    @attendances = Attendance.where(superior_id_for_overtime: params[:id], status_id_overtime: '申請中').order(:user_id, :applied_on)
    @users = User.all
  end
  
  def update_overtimes
    update_overtimes_params.each do |id, item|
      if ActiveRecord::Type::Boolean.new.cast(item[:permit])
        overtime = Attendance.find(id)
        overtime.update(status_id_overtime: item[:status_id_overtime])
        if overtime.status_id_overtime == '否認'
          overtime.update_attributes(end_overtime: nil, next_day_for_overtime: false)
        end
      end
    end
    flash[:success] = "残業申請を処理しました。"
    
    redirect_to user_url
  end
  
  ### 上長、一般ユーザからの残業申請 ###
  def edit_overtime # 残業申請作成ページ
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
  end
  
  def update_overtime
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if params[:attendance][:superior_id_for_overtime].blank?
      flash[:danger] = "申請先の上長を選択してください。"
    else
      unless @attendance.update_attributes(end_overtime: Time.zone.local(@attendance.worked_on.year, 
                                                                         @attendance.worked_on.month, 
                                                                         @attendance.worked_on.day, 
                                                                         params[:attendance]["end_overtime(4i)"].to_i, 
                                                                         params[:attendance]["end_overtime(5i)"].to_i),
                                           status_id_overtime: '申請中',
                                           business_content: params[:attendance][:business_content],
                                           next_day_for_overtime: ActiveRecord::Type::Boolean.new.cast(params[:attendance][:next_day_for_overtime]),
                                           superior_id_for_overtime: params[:attendance][:superior_id_for_overtime])
        flash[:danger] = "申請に失敗しました。"
      else
        flash[:success] = "#{l(@attendance.worked_on, format: :short)}の残業を申請しました。申請をお待ち下さい。"
      end
    end
    redirect_to @user
  end
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), first_started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), first_finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_attendances
    @attendances = Attendance.where(superior_id: params[:id], status_id: '申請中').order(:user_id, :worked_on)
    @users = User.all
  end
  
  def update_attendances
    ActiveRecord::Base.transaction do # トランザクションを開始します
      update_attendances_params.each do |id, item|
        if ActiveRecord::Type::Boolean.new.cast(item[:permit])
          attendance = Attendance.find(id)
          attendance.update(status_id: item[:status_id])
          if attendance.status_id == '承認'
            attendance.update_attributes!(started_at: attendance.applying_started_at,
                                          finished_at: attendance.applying_finished_at,
                                          next_day: attendance.applying_next_day,
                                          note: attendance.applying_note)
            attendance.update_attributes!(applying_started_at: nil, applying_finished_at: nil, applying_next_day: false, applying_note: nil)
          elsif attendance.status_id == '否認'
            attendance.update_attributes!(applying_started_at: nil, applying_finished_at: nil, applying_next_day: false, applying_note: nil)
          end
        end
      end
      flash[:success] = "勤怠修正申請を処理しました。"
      redirect_to user_url
    end
    
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐
    flash[:danger] = "エラーがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def edit_one_month
  end
  
  def update_one_month
    dates_on = []
    ActiveRecord::Base.transaction do # トランザクションを開始します
      attendances_params.each do |id, item|
        if item[:superior_id].present? 
          attendance = Attendance.find(id)
          attendance.update_attributes!(applying_started_at:  Time.zone.local(attendance.worked_on.year, 
                                                                              attendance.worked_on.month, 
                                                                              attendance.worked_on.day, 
                                                                              params[:user][:attendances][id]["applying_started_at(4i)"].to_i, 
                                                                              params[:user][:attendances][id]["applying_started_at(5i)"].to_i),
                                        applying_finished_at: Time.zone.local(attendance.worked_on.year, 
                                                                              attendance.worked_on.month, 
                                                                              attendance.worked_on.day, 
                                                                              params[:user][:attendances][id]["applying_finished_at(4i)"].to_i, 
                                                                              params[:user][:attendances][id]["applying_finished_at(5i)"].to_i),
                                        applying_next_day: ActiveRecord::Type::Boolean.new.cast(item[:next_day]),
                                        applying_note: item[:note],
                                        status_id: '申請中',
                                        superior_id: item[:superior_id])
          dates_on.push(l(Attendance.find(id).worked_on, format: :short))
        end
      end
    end
    if dates_on.count > 0
      flash[:success] = "#{dates_on.join(', ')}の勤怠修正を申請しました。承認をお待ち下さい。"
    else
      flash[:danger] = "最低でも1つはチェックを入れてください。"
    end
    redirect_to user_url(date: params[:date])
    
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def logs
    @user = User.find(params[:id])
    if params["date(1i)"] || params["date(2i)"]
      @attendances = Attendance.where(status_id: '承認', user_id: @user.id, worked_on: Date.new(params["date(1i)"].to_i, params["date(2i)"].to_i, 1).in_time_zone.all_month).order(:worked_on) 
    else 
      @attendances = Attendance.where(status_id: '承認', user_id: @user.id).order(:worked_on) 
    end
  end
  
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:applying_started_at, :applying_finished_at, :next_day, :note, :superior_id])[:attendances]
    end
    
    def update_attendances_params
      params.require(:attendance).permit(attendances: [:status_id, :permit])[:attendances]
    end
    
    def update_overtimes_params
      params.require(:attendance).permit(overtimes: [:status_id_overtime, :permit])[:overtimes]
    end
end
