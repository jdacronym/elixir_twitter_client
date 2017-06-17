defmodule Authenticate do
  require Logger
  import Helpers, only: [unwrap: 1]

  @consumer_key Application.get_env(:twitter, :consumer_key)
  @consumer_secret Application.get_env(:twitter, :consumer_secret)

  @oauth_url "https://api.twitter.com/oauth2"
  @request_body "grant_type=client_credentials"

  def app_only do
    get_bearer_token_from_env() |> handle_bearer_token_from_env
  end

  def get_bearer_token_from_env do
    Application.get_env(:twitter, :app_only_bearer_token)
  end

  def set_bearer_token(pair = {:ok, token}) do
    Application.put_env(:twitter, :app_only_bearer_token, token)
    pair
  end

  def handle_bearer_token_from_env(nil) do
    {:ok, _token} = post() |> decode_response |> set_bearer_token
  end
  def handle_bearer_token_from_env(token) do
    {:ok, token}
  end

  def post do
    HTTPoison.post("#{@oauth_url}/token", @request_body, headers()) |> unwrap
  end

  def decode_response(%{body: body}) do
    body |> Poison.decode |> unwrap |> handle_json
  end

  def handle_json(%{"errors" => errors}) do
    for err <- errors, do: log_err(err)
    {:error, errors}
  end
  def handle_json(%{"access_token" => token, "token_type" => "bearer"}) do
    {:ok, token}
  end

  def log_err( %{"label" => label, "message" => message, "code" => code}) do
    Logger.warn("#{label}: #{message} (code #{code})")
  end

  def encoded_secret, do: @consumer_secret |> URI.encode

  def encoded_token, do: "#{@consumer_key}:#{encoded_secret()}" |> Base.encode64

  def headers do
    [{"Authorization", "Basic #{encoded_token()}"},
     {"Content-type", "application/x-www-form-urlencoded"}]
  end
end
