class User < ActiveRecord::Base
  # this is a demo app; you probably don't want to hard-code YOUR user ids.
  FLEMING = 1
  STAFF = 2

  scope :doctors, -> { where(role: Role.doctor) }
  scope :staff, -> { where(role: Role.staff) }

  validates :role_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: { message: "Prescribers must have a last name" }, if: :prescriber?
  validates :npi, presence: { message: "Prescribers must have an npi" }, if: :prescriber?
  validate :valid_npi?, if: :prescriber?

  belongs_to :role
  has_many :pa_requests

  def display_name
    "#{role == Role.doctor ? 'Dr. ' : ''}#{first_name} #{last_name}"
  end

  def prescriber?
    role == Role.doctor
  end

  def valid_npi?
    unless npi && npi.size == 10 && npi =~ /^\d+$/
      errors.add(:valid_npi, "must be 10 digits")
    end
  end
  private :valid_npi?

end
