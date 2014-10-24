module Corr

  def id
    fail "All Corrs must implement an id() method"
  end

  def id=
    fail "All Corrs must implement an id=() method"
  end

  def listen
    fail "All Corrs must implement a listen() method"
  end

  def tell
    fail "All Corrs must implement a tell() method"
  end

end
