defmodule Timeline do
  import Helpers, only: [unwrap: 1]

  @endpoint Application.get_env(:twitter, :api_endpoint)
  
  def of(screen_name, count \\ 10) do
    HTTPoison.get(get_url(screen_name,count), headers()) |> unwrap |> decode
  end

  ## This code knows too much. Time to refactor
  def decode(%{body: body}), do: body |> Poison.decode |> unwrap
  def get_url(screen_name, count), do: "#{timeline_url()}?#{query(screen_name ,count)}"
  def query(screen_name, count), do: "count=#{count}&screen_name=#{screen_name}"
  def headers, do: [user_agent, auth_header]
  def user_agent, do: {"User-Agent", "ExTweet 0.1"}
  def auth_header, do: {"Authorization", "Bearer #{auth_token()}"}
  def auth_token, do: Authenticate.app_only() |> unwrap
  def timeline_url, do: "#{@endpoint}/1.1/statuses/user_timeline.json"
end
