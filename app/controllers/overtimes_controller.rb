class OvertimesController < ApplicationController

  def update_overtimes

    update_overtimes_params.each do |id, item|
      if item[:permit] == '1'
        overtime = Overtime.find(id)
        overtime.update_attributes!(item)
      end
    end
    flash[:success] = "残業申請を処理しました。"
    
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

  def edit_overtimes
    @overtimes = Overtime.where(superior_id: params[:id], status_id: 2).order(:user_id, :applied_on)
    @users = User.all
  end
  
  private
  
    def overtime_params
      params.require(:overtime).permit(:applied_on, :end_overtime, :business_content, :superior_id)
    end
    
    def update_overtimes_params
      params.require(:overtime).permit(overtimes: [:status_id, :permit])[:overtimes]
    end
end
