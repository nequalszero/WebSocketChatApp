shared_examples "responds with a successful status code" do
  it "responds with a successful status code" do
    expect(response).to have_http_status(200)
  end
end

shared_examples "responds with a 422 status code" do
  it "responds with a 422 status code" do
    expect(response).to have_http_status(422)
  end
end

shared_examples "responds with a 403 status code" do
  it "responds with a 403 status code" do
    expect(response).to have_http_status(403)
  end
end

shared_examples "responds with a 401 status code" do
  it "responds with a 401 status code" do
    expect(response).to have_http_status(401)
  end
end
