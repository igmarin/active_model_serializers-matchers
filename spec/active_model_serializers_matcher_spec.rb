require 'spec_helper'

describe ActiveModel::Serializers::Matchers do
  include ActiveModel::Serializers::Matchers

  it "is false if the serializer does not have an attribute" do
    serializer = Class.new ActiveModel::Serializer do
      attributes :foo
    end

    expect(serializer).to_not have_attribute :bar
    expect(serializer).to have_attribute :foo
  end

  it "matches singular attributes" do
    serializer = Class.new ActiveModel::Serializer do
      attribute :foo
    end

    expect(serializer).to_not have_attribute :bar
    expect(serializer).to have_attribute :foo
  end

  it "matches attributes with keys" do
    serializer = Class.new ActiveModel::Serializer do
      attribute :foo, :key => :foo_name
    end

    expect(serializer).to_not have_attribute :bar
    expect(serializer).to have_attribute :foo
    expect(serializer).to have_attribute(:foo).as(:foo_name)
    expect(serializer).to_not have_attribute(:foo).as(:another_name)
  end

  it "has `have_serialized_attribute` matcher" do
    serializer = Class.new ActiveModel::Serializer do
      attribute :foo, :key => :foo_name
    end

    expect(serializer).to_not have_serialized_attribute :bar
    expect(serializer).to have_serialized_attribute :foo
    expect(serializer).to have_serialized_attribute(:foo).as(:foo_name)
    expect(serializer).to_not have_serialized_attribute(:foo).as(:another_name)
  end

  it "matches the embed setting" do
    serializer = Class.new ActiveModel::Serializer do
      embed :ids
    end

    expect(serializer).to embed(:ids)
    expect(serializer).to_not embed(:objects)
  end

  describe "The root key" do
    it "matches the root setting" do
      serializer = Class.new ActiveModel::Serializer do

      end

      expect(serializer).to include_root
    end

    it "is able to match a specific key" do
      serializer = Class.new ActiveModel::Serializer do
        root :foo
      end

      expect(serializer).to include_root(:foo)
      expect(serializer).to_not include_root(:bar)
    end
  end

  describe "Associations" do
    it "works with has_many" do
      serializer = Class.new ActiveModel::Serializer do
        has_many :foos
      end

      expect(serializer).to have_many(:foos)
      expect(serializer).to_not have_many(:bars)
    end

    it "works with has_many via have_many_serialized" do
      serializer = Class.new ActiveModel::Serializer do
        has_many :foos
      end

      expect(serializer).to have_many_serialized(:foos)
    end

    it "works with has_one" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foo
      end

      expect(serializer).to have_one(:foo)
      expect(serializer).to_not have_one(:bar)
    end

    it "works with has_one via have_one_serialized" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foo
      end

      expect(serializer).to have_one_serialized(:foo)
      expect(serializer).to_not have_one_serialized(:bar)
    end

    it "works with has_one key options" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foo, :key => :bar
      end

      expect(serializer).to have_one(:foo).as(:bar)
      expect(serializer).to have_one(:foo)
      expect(serializer).to_not have_one(:foo).as(:qux)
    end

    it "works with has_many key options" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foos, :key => :bars
      end

      expect(serializer).to have_one(:foos).as(:bars)
      expect(serializer).to have_one(:foos)
      expect(serializer).to_not have_one(:foos).as(:qux)
    end
  end
end
