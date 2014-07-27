# include the full title method in ApplicationHelper to use for tests
include ApplicationHelper

# we do this instead of defining a message, because rspec generates
# human readable error messages for success and failure and we get them 
# via Rspec::Matchers. This is similar to defining a cucumber step and using it
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: 'Invalid')
  end
end