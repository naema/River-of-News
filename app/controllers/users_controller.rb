class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit, :destroy, :river]

  before_filter :require_login, except: [:new, :create, :river]

  after_action :allow_iframe, only: :river

  respond_to :html, :json

  # GET /users/1
  # GET /users/1.json
  def show
    if @user = current_user
      @google_fonts = google_fonts
    else
      redirect_to '/user_sessions/new'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      @google_fonts = google_fonts
      auto_login @user
      redirect_to root_url
    else
      render '/users/new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = 'Your settings were successfully updated.'
      respond_with @user
    else
      redirect_to :back, :alert => @user.errors.messages.map{|k,v|"#{k.to_s.titleize}: #{v.join(', ')}"}.join('<br>')
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_with @user
  end

  def welcome
    if @user = current_user
      @google_fonts = google_fonts
    end
  end


  # GET /users/1/river
  def river
    @river = Rails.cache.fetch(@user.api_url, expires_in: 1.minute) do
      response = Net::HTTP.get_response(URI.parse(@user.api_url)).body
      Hash.from_xml(response)['items']['item']
          .map{|e| e['published_at'] = Time.parse(e['published_at']).to_i; e}
          .sort_by{|e| -e['published_at']}
    end rescue [] # TODO: improve error handling
    @river.select!{|e| e['published_at'] > params[:newest_published_at].to_i} if params[:newest_published_at]
    if request.xhr?
      render layout: false
    else
      # render only layout without river.html.haml
      render file: "/layouts/river_layout", layout: false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :font_name, :font_size, :font_color,
                                   :box_color, :api_url, :border_color)
    end

    def google_fonts
      Rails.cache.fetch('fonts/google', expires_in: 3.hours) do
        # TODO: improve error handling
        Net::HTTP.get_response(URI.parse('http://static.scripting.com/google/webFontNames.txt')).body.split("\r")
      end
    end

    def allow_iframe
      response.header['X-Frame-Options'] = 'ALLOW'
    end

    def require_login
      unless current_user
        redirect_to login_url
      end
    end
end
