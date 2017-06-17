defmodule AuthenicateTest do
  use ExUnit.Case

  test 'includes Authorization header' do
    assert {"Authorization", _} = authorization_header()
  end
  

  test 'Doesn\'t leave the token unencoded' do
    assert authorization_header() != {"Authorization", "Basic #{unencoded_token()}"}
  end

  test 'Includes the authorization header' do
    assert authorization_header() != {"Authorization", "Basic "}
  end

  test 'application-only auth' do
    assert {:ok, _token} = Authenticate.app_only
  end

  def authorization_header do
    Authenticate.headers |> Enum.find(&({"Authorization", _} = &1))
  end

  def unencoded_token do
    consumer_token = Application.get_env(:twitter, :consumer_token)
    consumer_secret = Application.get_env(:twitter, :consumer_secret)
    "#{consumer_token}:#{consumer_secret}"
  end
end
