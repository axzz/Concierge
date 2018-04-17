require "spec_helper"

describe MiniprogramAdmin::Views::ApplicationLayout do
  let(:layout)   { MiniprogramAdmin::Views::ApplicationLayout.new(template, {}) }
  let(:rendered) { layout.render }
  let(:template) { Hanami::View::Template.new('apps/miniprogram_admin/templates/application.html.erb') }

  it 'contains application name' do
    rendered.must_include('MiniprogramAdmin')
  end
end
