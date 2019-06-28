class OvertimesController < ApplicationController

  def update
    if Overtime.find_by(id: @user.id, applied_on: @attendance.worked_on)
    
    else # 残業申請されてるテーブルが存在しないなら新規作成する
      Overtime.create(applied_on: params, end_overtime: params, permit_note: params)
    end
    
    redirect_to users_url
  end
  
  def new
    
  end
end
