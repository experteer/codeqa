require 'spec_helper'

describe Codeqa::ConfigLoader do
  context "#deep_merge" do
    it "can merge simple hashes" do
      h1 = {:some => 'value'}
      h2 = {:other => 'key'}
      expect(Codeqa::ConfigLoader.deep_merge(h1,h2)).to eql({:some => 'value', :other => 'key'})
    end
    it "can merge hashes with same key" do
      h1 = {:some => 'value'}
      h2 = {:some => 'key'}
      expect(Codeqa::ConfigLoader.deep_merge(h1,h2)).to eql({:some => 'key'})
    end
    it "can merge arrays as keys" do
      h1 = {:some => [1,2,3]}
      h2 = {:some => [2,3,4]}
      expect(Codeqa::ConfigLoader.deep_merge(h1,h2)).to eql({:some => [1,2,3,4]})
    end
    it "can merge hashes as keys" do
      h1 = {:some => {:deep => 'keys'}}
      h2 = {:some => {:deep => 'values', :and => 'more'}}
      expect(Codeqa::ConfigLoader.deep_merge(h1,h2)).to eql({:some => {:deep => 'values', :and => 'more'}})
    end
  end
end