require 'spec'
require "#{File.dirname(__FILE__)}/../lib/jwt.rb"

payload = {"foo" => "bar"}

describe JWT do
  it "encodes and decodes JWTs" do
    secret = "secret"
    jwt = JWT.encode(payload, secret)
    decoded_payload = JWT.decode(jwt, secret)
    decoded_payload.should == payload
  end
  
  it "decodes valid JWTs" do
    example_payload = {"hello" => "world"}
    example_secret = 'secret'
    example_jwt = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJoZWxsbyI6ICJ3b3JsZCJ9.YjZmNmEwMmMzMmU4NmEyMjRhYzRlMmFhYTQxNWQyMTA2Y2JiNDk4NGEyN2Q5ODYzOWVkODI2ZjVjYjY5Y2EzZg'
    decoded_payload = JWT.decode(example_jwt, example_secret)
    decoded_payload.should == example_payload
  end

  it "raises exception with wrong key" do
    right_secret = 'foo'
    bad_secret = 'bar'
    jwt_message = JWT.encode(payload, right_secret)
    lambda { JWT.decode(jwt_message, bad_secret) }.should raise_error(JWT::DecodeError)
  end
  
  it "allows decoding without key" do
    right_secret = 'foo'
    bad_secret = 'bar'
    jwt = JWT.encode(payload, right_secret)
    decoded_payload = JWT.decode(jwt, bad_secret, false)
    decoded_payload.should == payload
  end
  
  it "raises exception on unsupported crypto algorithm" do
    lambda { JWT.encode(payload, "secret", 'HS1024') }.should raise_error(NotImplementedError)
  end
end