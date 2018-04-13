require "spec_helper"

describe Miniprogram::Views::ApplicationLayout do
  let(:layout)   { Miniprogram::Views::ApplicationLayout.new(template, {}) }
  let(:rendered) { layout.render }
  let(:template) { Hanami::View::Template.new('apps/miniprogram/templates/application.html.erb') }

  it 'contains application name' do
    rendered.must_include('Miniprogram')
  end
end
