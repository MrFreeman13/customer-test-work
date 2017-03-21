class AppointmentsController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def new
    session[:appointment_params] ||= {}
    @appointment = Appointment.new
    @appointment.user = @user
    @appointment.build_address
  end

  def create
    session[:appointment_params].deep_merge!(prepare_params.compact) if params[:appointment]
    @appointment = Appointment.new(session[:appointment_params])
    @appointment.user = @user
    @appointment.current_step = session[:appointment_step]

    if @appointment.valid?
      if params[:back_button]
        @appointment.previous_step
      elsif @appointment.last_step?
        @appointment.save if @appointment.all_valid?
      else
        @appointment.next_step
      end
      session[:appointment_step] = @appointment.current_step
    end

    if @appointment.new_record?
      render :new
    else
      session[:appointment_step] = session[:appointment_params] = nil
      flash[:notice] = 'Appointment saved.'
      redirect_to new_user_appointment_url
    end
  end

  private
    def set_appointment
      if params[:id]
        @appointment = Appointment.find(params[:id])
      else
        @appointment = Appointment.new(session[:appointment_params])
      end
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
