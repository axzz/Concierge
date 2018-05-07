require_relative '../../../spec_helper'

# Spec for miniprogram Reservation
describe Miniprogram::Controllers::Reservation::Create do
  let(:action) { Miniprogram::Controllers::Reservation::Create.new }
  let(:get_sms) { Miniprogram::Controllers::Index::Sms.new }
  let(:get_index) { Miniprogram::Controllers::Reservation::Index.new }
  let(:cancel) { Miniprogram::Controllers::Reservation::Cancel.new }
  let(:token) { Tools.make_miniprogram_jwt(1) }
  let(:project) { ProjectRepository.new.find(2) }

  it 'no token' do
    response = action.call({})
    response[0].must_equal 401
  end

  it 'success' do
    get_sms.call(id: 2, tel: '13408058303', token: token)
    response = make_reservation
    response[0].must_equal 201
  end

  def make_reservation
    time_tables = DayTableRepository.new(project.id).get_tables(7)
    date = time_tables[1][:date]
    time = time_tables[1][:table][0][:time]
    params = {
      code: '123456',
      project_id: '2',
      token: token,
      name: 'lululu',
      tel:  '13408058303',
      date: date,
      time: time
    }
    action.call(params)
  end

  it 'get reservation index' do
    response = make_reservation
    id = JSON.parse(response[2][0])["id"]
    response = get_index.call({ token: token })
    get_index.reservations[0].reservation_id.must_equal id
  end

  it 'cancel reservation' do
    response = make_reservation
    id = JSON.parse(response[2][0])["id"]
    cancel.call(token: token, id: id)
    ReservationRepository.new.find(id.to_i).state.must_equal 'cancelled'
  end
end
