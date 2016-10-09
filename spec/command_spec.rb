require 'spec_helper'

describe Primix::Command do

  it "runs" do
    Primix::Command.run(["install"])
  end
end
