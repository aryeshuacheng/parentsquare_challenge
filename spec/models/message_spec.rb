RSpec.describe 'Message' do
  context "generate provider URIs"
  it 'ensure that uri/alternate_ui are set properly and also ensure the pair of URIs are set properly' do
    provider = Message.choose_provider

    expect(provider[:uri].to_s).to eq('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1').or eq('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
    expect(provider[:alternate_uri].to_s).to eq('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1').or eq('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')

    if provider[:uri].to_s == ('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
      provider[:alternate_uri].to_s == ('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
    elsif provider[:uri].to_s == ('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
      provider[:alternate_uri].to_s == ('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
    end
    
    expect(provider[:uri]).not_to eq(provider[:alternate_uri])
  end

  it 'method choose_provider returns a hash containing a URI and Alternate URI' do

  end
end