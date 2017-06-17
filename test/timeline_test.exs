defmodule TimelineTest do
  use ExUnit.Case

  ## this is a test of the Twitter API, and thus doesn't belong here
  test 'gets the timeline of a user' do
    tweets = Timeline.of("twitter", 5)
    assert Kernel.is_list(tweets)
    for tweet <- tweets, do: assert %{ "text" => _ } = tweet
  end

  test 'headers contains the bearer token' do
    ## arrange
    # cache a fake bearer token so we don't use the network
    Application.put_env(:twitter, :app_only_bearer_token, "DEADBEEF")

    ## act
    {"Authorization", hdr} = Timeline.headers |> Enum.find(
      fn tuple = {"Authorization", _} -> tuple; _ -> nil end
    )

    ## assert
    assert hdr == "Bearer DEADBEEF"

    ## teardown
    Application.put_env(:twitter, :app_only_bearer_token, nil)
  end

  test 'decode unboxes the json body of a request' do
    assert Timeline.decode(%{body: ~s|{"hello": "world"}|}) == %{"hello" => "world"}
  end

  test 'query generates the timeline query string' do
    assert Timeline.query("user",10) == "count=10&screen_name=user"
  end

  test 'timeline_url gives a request URL' do
    assert Timeline.timeline_url == "https://api.twitter.com/1.1/statuses/user_timeline.json"
  end

  test 'get_url builds a full url' do
    assert Timeline.get_url("user", 10) ==
      "https://api.twitter.com/1.1/statuses/user_timeline.json?count=10&screen_name=user"
  end
end
