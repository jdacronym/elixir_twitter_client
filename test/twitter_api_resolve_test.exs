defmodule TwitterAPIResolveTest do
  use ExUnit.Case

  alias Twitter.API.Resolve, as: TAR

  test 'resolves to a set of four IPs on the same subnet' do
    assert [{a, b, c, _}, {a, b, c, _}, {a, b, c, _}, {a, b, c, _}] = TAR.ips()
  end
end
