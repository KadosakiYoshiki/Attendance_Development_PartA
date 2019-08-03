class CentersController < ApplicationController
  
  before_action :admin_user
  
  def index
    @centers = Center.all
    @user = Center.new
  end
  
  def edit
    @center = Center.find(params[:id])
  end
  
  def new
    @center = Center.new
  end
  
  def create
    @center = Center.new(center_params)
    if @center.save
      flash[:success] = "新規作成に成功しました。"
      redirect_to centers_path
    else
      render :new
    end
  end
  
  def update
    @center = Center.find(params[:id])
    if @center.update_attributes(center_params)
      flash[:success] = "更新に成功しました。"
      redirect_to centers_path
    else
      render :edit
    end
  end
  
  def destroy
    @center = Center.find(params[:id])
    flash[:danger] = "#{@center.name}の拠点情報を消去しました"
    @center.destroy
    redirect_to centers_path
  end
  
  private
    def center_params
      params.require(:center).permit(:number, :name, :attendance_type)
    end
end
