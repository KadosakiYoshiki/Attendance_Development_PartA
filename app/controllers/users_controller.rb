class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :make_apply_overworking]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :duty, :destroy, :edit_basic_info, :update_basic_info, :edit_system_info]
  before_action :reject_admin_user, only: :show
  before_action :superior_or_correct_user, only: :show
  before_action :set_one_month, only: :show

  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end
  
  def duty
    @dutys = Attendance.where(worked_on: Date.current).where.not(started_at: nil).where(finished_at: nil)
    @users = User.all
  end
  
  def show
    unless @approval = Approval.find_by(user_id: @user.id, month: @first_day)
      @approval = Approval.new(user_id: @user.id, month: @first_day)
    end
    @worked_sum = @attendances.where.not(started_at: nil).count
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "#{@user.name + l(@first_day, format: :middle)}勤怠情報.csv", type: :csv
      end
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 新規保存後ログインする
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def import
=begin
  現状：正しい形式で登録しないとエラーになり、処理が止まってしまう
  　　　新しく登録する扱いとなるが、IDを入力する必要がある
  目標：  間違った形式が含まれていた場合はそのレコードに対してバリデーションメッセージ表示
  　　　  　その場合は処理をスキップさせる
  　　　　CSVファイルにIDを入力する必要あるため、入力不要でID自動付与されるようにしていく
  参考にしたサイト：https://ruby-rails.hatenadiary.com/entry/20141120/1416483136#csv_import_import_csv
                    https://qiita.com/m-shin/items/7e8cdea2644e47b87fbf
                    
=end
    if params[:users_file] && File.extname("#{params[:users_file].original_filename}") == ".csv"
      # 登録処理前のレコード数
      current_user_count = User.count
      users = []
      # windowsで作られたファイルに対応するので、encoding: 'UTF-8'を付けている
      CSV.foreach(params[:users_file].path, headers: true, encoding: "UTF-8") do |row|
        users << User.create({ 
          name:                       row['name'],
          email:                      row['email'],
          department:                 row['affiliation'],
          employee_number:            row['employee_number'],	
          uid:                        row['uid'],
          basic_work_time:            row['basic_work_time'],
          designated_work_start_time: row['designated_work_start_time'],
          designated_work_end_time:   row['designated_work_end_time'],
          superior:                   row['superior'],
          admin:                      row['admin'],
          password:                   row['password'] })
      end
      # 何レコード登録できたかを返す
      flash[:success] = "#{User.count - current_user_count}人の情報を新規作成しました。"
    else
      flash[:danger] = "インポートするCSVファイルを選択してください。"
    end
    redirect_to users_path
    
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      # 更新成功時の処理
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      # 更新失敗時の処理
      flash[:danger] = "#{@user.name}の更新は失敗しました。" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_system_info
    
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :department, :employee_number, :uid, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :password, :password_confirmation, :basic_time, :work_time)
    end
    
    def make_apply_overworking_params
      params.require(:overtime).permit(:user_id, :applied_on, :end_overtime, :permit_note)
    end
end
