require_relative '../../../spec_helper'

describe Web::Views::Index::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/index/index.html.erb') }
  let(:view)      { Web::Views::Index::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
