require_relative '../../../spec_helper'

describe Web::Views::Project::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/project/show.html.erb') }
  let(:view)      { Web::Views::Project::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
