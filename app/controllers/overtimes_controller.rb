class OvertimesController < ApplicationController

  def update
    if Overtime.find_by(id: @user.id, applied_on: @attendance.worked_on)
    
    else # 残業申請されてるテーブルが存在しないなら新規作成する
      Overtime.create(applied_on: params, end_overtime: params, permit_note: params)
    end
    
    redirect_to users_url
  end
  
  def new
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:format])
    @overtime = Overtime.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @superiors = User.where(superior: true)
    @overtime = Overtime.new(overtime_params)
    if (params[:overtime][:next_day] == '1')
      @overtime.end_overtime += 1.days
    end
    @overtime.user_id = params[:user_id]
    
    if @overtime.save
      flash[:success] = "残業を申請しました。承認をお待ち下さい。"
      redirect_to @user
    else
      flash[:danger] = "申請に失敗しました。"
      redirect_to users_url
    end
  end
  
  def index
  
  end
  
  private
  
    def overtime_params
      params.require(:overtime).permit(:applied_on, :end_overtime, :business_content, :superior_id)
    end
end
