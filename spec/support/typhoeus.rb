def mock_request(url, file_name)
  content = File.open(File.join(Rails.root, "spec/assets/#{file_name}")).read
  response = Typhoeus::Response.new(body: content)
  Typhoeus.stub(url).and_return(response)
end
