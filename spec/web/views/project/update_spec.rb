require_relative '../../../spec_helper'

describe Web::Views::Project::Update do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/project/update.html.erb') }
  let(:view)      { Web::Views::Project::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
