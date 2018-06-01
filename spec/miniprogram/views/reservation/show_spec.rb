require_relative '../../../spec_helper'

describe Miniprogram::Views::Reservation::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/miniprogram/templates/reservation/show.html.erb') }
  let(:view)      { Miniprogram::Views::Reservation::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
