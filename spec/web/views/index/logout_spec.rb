require_relative '../../../spec_helper'

describe Web::Views::Index::Logout do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/index/logout.html.erb') }
  let(:view)      { Web::Views::Index::Logout.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
