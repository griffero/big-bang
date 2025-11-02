class Phrase < ApplicationRecord
  has_many :addresses, dependent: :destroy

  enum :status, { pending: 0, processing: 1, done: 2 }

  validates :content, presence: true, uniqueness: { case_sensitive: false }

  before_validation :normalize_content

  private

  def normalize_content
    return if content.nil?

    normalized = content.strip.downcase
    self.content = normalized
  end
end


