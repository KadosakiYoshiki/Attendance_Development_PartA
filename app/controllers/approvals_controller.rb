class ApprovalsController < ApplicationController
  
  def show
  
  end
  
  def index
    
  end

  def create
    @user = User.find(params[:user_id])
    @approval = Approval.new(approval_params)
    if @approval.save
      flash[:success] = "#{l(@approval.month, format: :middle)}の勤怠申請をしました。承認をお待ち下さい。"
      redirect_to @user
    else
      flash[:danger] = "申請に失敗しました。"
      redirect_to users_url
    end
  end
  
  private
  
    def approval_params
      params.require(:approval).permit(:user_id, :month, :superior_id)
    end
end
