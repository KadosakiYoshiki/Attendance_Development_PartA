class ApprovalsController < ApplicationController
  
  def show
  
  end
  
  def index
    
  end
  
  def edit_approvals
    @approvals = Approval.where(superior_id: params[:id], status_id: '申請中').order(:user_id, :month)
    @users = User.all
  end
  
  def update_approvals
    ActiveRecord::Base.transaction do # トランザクションを開始します
      update_approvals_params.each do |id, item|
        if ActiveRecord::Type::Boolean.new.cast(item[:permit])
          approval = Approval.find(id)
          approval.update_attributes(item)
        end
      end
      flash[:success] = "申請を処理しました。"
      redirect_to users_url
    end
    
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐
    flash[:danger] = "エラーがあった為、更新をキャンセルしました。"
    redirect_to approvals_edit_one_month_user_url(date: params[:date])
  end

  def create
    @user = User.find(params[:user_id])
    @approval = Approval.new(approval_params)
    @approval.status_id = '申請中'
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
    
    def update_approvals_params
      params.require(:approval).permit(approvals: [:status_id, :permit])[:approvals]
    end
end
