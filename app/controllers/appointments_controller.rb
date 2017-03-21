class AppointmentsController < ApplicationController
  before_action :set_user, only: [:new, :create, :show]
  before_action :set_appointment, only: [:show]

  def new
    session[@user.id] ||= { appointment_params: {} }
    @appointment = Appointment.new
    @appointment.user = @user
    @appointment.build_address
  end

  def show
    @appointment.user = @user
    session[@user.id].symbolize_keys[:appointment_step] = :specialists
  end

  def create
    session[@user.id].symbolize_keys[:appointment_params].deep_merge!(prepare_params.compact) if params[:appointment]
    @appointment = Appointment.new(session[@user.id].symbolize_keys[:appointment_params])
    @appointment.user = @user
    @appointment.current_step = session[@user.id].symbolize_keys[:appointment_step]

    if @appointment.valid?
      if params[:back_button]
        @appointment.previous_step
      elsif @appointment.last_step?
        @appointment.save if @appointment.all_valid?
      else
        @appointment.next_step
      end
      session[@user.id].symbolize_keys[:appointment_step] = @appointment.current_step
    end

    if @appointment.new_record?
      render :new
    else
      session[@user.id].symbolize_keys[:appointment_step] = session[@user.id].symbolize_keys[:appointment_params] = nil
      flash[:notice] = 'Appointment saved.'
      redirect_to new_user_appointment_url
    end
  end

  private
    def set_appointment
      @appointment = Appointment.new(session[@user.id].symbolize_keys[:appointment_params])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def prepare_params
      appointment_params.merge({ "specialist" => appointment_params["specialist"].try(:to_i) })
    end

    def appointment_params
      params.require(:appointment).permit(:specialist, :scheduled_time, :user_id, :address_id, address_attributes: [:building, :street, :city, :country, :postal_code])
    end
end
