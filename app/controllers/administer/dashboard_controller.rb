class  Administer::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'just_admin'

  def index

  end

  def search
    @videos = Video.where("title like '%#{params[:query]}%'").recent.paginate(per_page:10,page:params[:page])
  end

  def channel
    @column = Column.find_by_english(params[:english])
    @videos = Video.where(column_id: @column.id).recent.paginate(per_page:10,page:params[:page])
  end

  def users
    unless params[:query].present?
      @users = User.recent.paginate(per_page:10,page:params[:page])
    else
      @users = User.where("nick_name like '%#{params[:query]}%' OR email like '%#{params[:query]}%'").role_asc.paginate(per_page:10,page:params[:page])
    end
  end

  def role_control
    if Settings.role_string.include?(params[:role])
      role_user = User.find(params[:user_id])
      role_user.role = params[:role]
      role_user.save
      flash[:notice] ="『#{display_name role_user}』变更为「#{display_role role_user}」"
      redirect_to users_path
    else
      flash[:error] ="权限操作失败"
      redirect_to users_path
    end
  end

  def set_skin_style
    if current_user
      current_user.web_style = params[:skin]
      current_user.save
    end
  end

end
