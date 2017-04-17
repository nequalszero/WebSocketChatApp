# require_logged_in_spec_helper.rb

# Ensures that the response given matches that given by the ApplicationController
#   require_logged_in method.
shared_examples 'require logged in' do

  it 'responds with a 401 status code' do
    expect(response).to have_http_status(401)
  end

  it 'states that the user must be logged in' do
    expect(response.body).to include('You must be logged in to do that.')
  end
end
