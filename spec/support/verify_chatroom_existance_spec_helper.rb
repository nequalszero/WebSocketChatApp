# verify_chatroom_existance_spec_helper.rb

# Ensures that the given chatroom_id matches an existing chatroom.
shared_examples 'verify chatroom existance' do
  it 'responds with a 422 status code' do
    expect(response).to have_http_status(422)
  end

  it 'states that the request chatroom does not exist' do
    expect(response.body).to include('Unprocessible entity - chatroom does not exist')
  end
end
