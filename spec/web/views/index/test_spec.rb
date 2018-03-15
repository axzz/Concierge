require_relative '../../../spec_helper'

describe Web::Views::Index::Test do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/index/test.html.erb') }
  let(:view)      { Web::Views::Index::Test.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
