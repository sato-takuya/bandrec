class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,:trackable ,:confirmable
  validates :name, presence: true

  generate_public_uid

  has_one_attached :profile_picture
  has_many :instruments,dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  extend OrderAsSpecified

  validates :info, length: { maximum: 3000 }


  def to_param
    public_uid
  end

  scope :user_type,->(pub){where(user_type: pub).where.not(user_type: 3)}#ユーザータイプは何か

  scope :inst,->(kk){where(id: kk)}#楽器

  scope :area,->(pub){where(area: pub)}#居住地

  scope :gender,->(pub){where(gender: pub)}

  scope :job,->(pub){where(job: pub)}

  scope :future,->(pub){where(future: pub)}

  scope :age,->(pub){where(birthday: pub)}

  scope :info,->(pub){where('info LIKE(?)', "%#{pub}%")}

  scope :band_type,->(pub){where(band_type: pub)}

  scope :song_type,->(pub){where(song_type: pub)}

end
