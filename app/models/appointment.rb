class Appointment < ActiveRecord::Base
  attr_writer :current_step

  enum specialist: [:Electrician, :Plumber, :Mechanic, :Technician_Other]
  validates_presence_of :specialist, :user_id
  validates_presence_of :scheduled_time, :if => lambda { |o| o.current_step == "address" }

  belongs_to :user
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[specialists scheduled_time address]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
end
