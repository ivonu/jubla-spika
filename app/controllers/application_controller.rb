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
      @publish_num += Comment.where.not(delete_comment: nil).count;
      @publish_num += Attachment.where.not(delete_comment: nil).count;
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
    @pictures = Picture.all.reverse
  end

  def about
    @page = Page.where(title: 'Ueber uns').first
  end

  def contact
    @page = Page.where(title: 'Kontakt').first
  end

  def faq
    @page = Page.where(title: 'FAQ').first
  end

  def agb
    @page = Page.where(title: 'AGB').first
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
    program.age_5 = false
    program.age_8 = false
    program.age_12 = false
    program.age_15 = false
    program.age_17 = false
    program.time_min = 5
    program.time_max = 180
    program.indoors = false
    program.outdoors = false
    program.act_active = false
    program.act_calm = false
    program.act_creative = false
    program.act_talk = false
    program.cat_game = false
    program.cat_shape = false
    program.cat_group = false
    program.cat_jubla = false
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
      program.age_5 = program.age_5 || entry.age_5
      program.age_8 = program.age_8 || entry.age_8
      program.age_12 = program.age_12 || entry.age_12
      program.age_15 = program.age_15 || entry.age_15
      program.age_17 = program.age_17 || entry.age_17
      program.time_min += entry.time_min
      program.time_max += entry.time_max
      program.indoors = program.indoors || entry.indoors
      program.outdoors = program.outdoors || entry.outdoors
      program.act_active = program.act_active || entry.act_active
      program.act_calm = program.act_calm || entry.act_calm
      program.act_creative = program.act_creative || entry.act_creative
      program.act_talk = program.act_talk || entry.act_talk
      program.cat_game = program.cat_game || entry.cat_game
      program.cat_shape = program.cat_shape || entry.cat_shape
      program.cat_group = program.cat_group || entry.cat_group
      program.cat_jubla = program.cat_jubla || entry.cat_jubla
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
