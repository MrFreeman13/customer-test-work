module AppointmentsHelper
  def specialist_collections
    @appointment.class.specialists.map.with_index{ |element, index| [element.first.gsub('_', ' '), index] }
  end

  def selected_value
    Appointment.specialists[@appointment.specialist]
  end
end
