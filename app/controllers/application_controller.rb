class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include AuthorizationHelper
  rescue_from AuthorizationError, with: :user_not_authorized

  before_action :configure_permitted_parameters_for_devise, if: :devise_controller?

  before_filter :load_links
  before_filter :publish_num
  before_filter :unfinished_programs

  def load_links
    @links = Link.all()
  end

  def publish_num
    if user_signed_in? and current_user.is_moderator?
      @publish_num = Entry.where(published: false).count
      @publish_num += Entry.where.not(delete_comment: nil).count;
      @publish_num += Program.where(done: true, published: false).count;
      @publish_num += Program.where.not(edited_title: nil).count;
      @publish_num += ProgramEntry.where.not(delete_comment: nil).count;
      @publish_num += Program.where.not(delete_comment: nil).count;
      @publish_num += Comment.where(published: false).count
    end
  end

  def unfinished_programs
    @unfin_programs = false
    if user_signed_in?
      if current_user.programs.where(done: false).count > 0
        @unfin_programs = true
        @unfin_programs_ref = current_user.programs.where(done: false);
      end
    end
  end

  def index
    @entries = Entry.where(published: true).last(5).reverse
    @news = News.paginate(:page => params[:page], :per_page => 3).order('id DESC')
  end

  def about

  end

  def contact

  end

  def theory

  end

  def new_idea

  end

  def update_program_attributes(program)
    program.search_text = ""
    program.material = ""
    program.preparation = ""
    program.remarks = ""
    program.group_size_min = 2
    program.group_size_max = 100
    program.age_min = 5
    program.age_max = 99
    program.time_min = 5
    program.time_max = 180
    program.indoors = false
    program.outdoors = false
    program.weather_snow = false
    program.weather_rain = false
    program.weather_sun = false
    program.act_active = false
    program.act_calm = false
    program.act_creative = false
    program.cat_pocket = false
    program.cat_craft = false
    program.cat_cook = false
    program.cat_pioneer = false
    program.cat_night = false
    program.entries.each do |entry|
      program.search_text += " " + entry.title
      program.search_text += " " + entry.title_other
      program.search_text += " " + entry.description
      program.search_text += " " + entry.keywords
      if not entry.material.empty? then
        program.material += "\n" unless program.material.empty?
        program.material += entry.material
      end
      if not entry.preparation.empty? then
        program.preparation += "\n" unless program.preparation.empty?
        program.preparation += entry.preparation
      end
      if not entry.remarks.empty? then
        program.remarks += "\n" unless program.remarks.empty?
        program.remarks += entry.remarks
      end
      program.group_size_min = [program.group_size_min, entry.group_size_min].max
      program.group_size_max = [program.group_size_max, entry.group_size_max].min
      program.age_min = [program.age_min, entry.age_min].max
      program.age_max = [program.age_max, entry.age_max].min
      program.time_min += entry.time_min
      program.time_max += entry.time_max
      program.indoors = program.indoors || entry.indoors
      program.outdoors = program.outdoors || entry.outdoors
      program.weather_snow = program.weather_snow || entry.weather_snow
      program.weather_rain = program.weather_rain || entry.weather_rain
      program.weather_sun = program.weather_sun || entry.weather_sun
      program.act_active = program.act_active || entry.act_active
      program.act_calm = program.act_calm || entry.act_calm
      program.act_creative = program.act_creative || entry.act_creative
      program.cat_pocket = program.cat_pocket || entry.cat_pocket
      program.cat_craft = program.cat_craft || entry.cat_craft
      program.cat_cook = program.cat_cook || entry.cat_cook
      program.cat_pioneer = program.cat_pioneer || entry.cat_pioneer
      program.cat_night = program.cat_night || entry.cat_night
    end
    return program
  end

  protected
  def configure_permitted_parameters_for_devise
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :first_name
    devise_parameter_sanitizer.for(:account_update) << :last_name
  end

  private
    def user_not_authorized
      flash[:alert] = 'Leider bist du nicht angemeldet oder hast keine Berechtigung fuer diese Aktion.'
      redirect_to(request.referrer || root_path)
    end
end
