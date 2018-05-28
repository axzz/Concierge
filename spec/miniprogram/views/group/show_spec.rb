require_relative '../../../spec_helper'

describe Miniprogram::Views::Group::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/miniprogram/templates/group/show.html.erb') }
  let(:view)      { Miniprogram::Views::Group::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
