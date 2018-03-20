require_relative '../../../spec_helper'

describe Web::Views::Index::TestPost do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/index/test_post.html.erb') }
  let(:view)      { Web::Views::Index::TestPost.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
