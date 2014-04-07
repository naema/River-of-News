class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: :password_validation_required
  validates :password, confirmation: true, if: :password_validation_required
  validates :password_confirmation, presence: true, if: :password_validation_required
  validates :font_name, allow_blank: true, format: {
      with: /\A[\w\-\s]+\z/i,
      message: 'Font name is invalid'
  }
  # validate ALL the colors
  [:box, :font, :border].each do |what_color|
    what = "#{what_color}_color".to_sym
    validates what, allow_blank: false, format: {
      with: /\A\#[a-z0-9]{6}\z/i,
      message: "#{what} is invalid"
    }
  end
  validates :api_url, allow_blank: false, format: {
      with: /\Ahttps?\:\/\/www\.mynewsdesk\.com\/partner\/api.*?\z/i,
      message: 'API URL is invalid only API URLs from mynewsdesk.com are allowed'
  }, if: :api_url_validation_required

  validates :email, uniqueness: true
  validates :font_size, numericality: true, on: :update

  DEFAULT_FONTS = ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier',
                   'Courier New', 'Georgia', 'Helvetica', 'Impact',
                   'Palatino', 'Times New Roman', 'Trebuchet MS', 'Verdana']

  private
    def password_validation_required
      password
    end

    def api_url_validation_required
      api_url
    end
end
