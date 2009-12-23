# encoding: utf-8
require 'cases/helper'
require 'cases/tests_database'

require 'models/topic'
require 'models/developer'
require 'models/person'

class ConfirmationValidationTest < ActiveModel::TestCase
  include ActiveModel::TestsDatabase

  def teardown
    Topic.reset_callbacks(:validate)
  end

  def test_no_title_confirmation
    Topic.validates_confirmation_of(:title)

    t = Topic.new(:author_name => "Plutarch")
    assert t.valid?

    t.title_confirmation = "Parallel Lives"
    assert !t.valid?

    t.title_confirmation = nil
    t.title = "Parallel Lives"
    assert t.valid?

    t.title_confirmation = "Parallel Lives"
    assert t.valid?
  end

  def test_title_confirmation
    Topic.validates_confirmation_of(:title)

    t = Topic.create("title" => "We should be confirmed","title_confirmation" => "")
    assert !t.save

    t.title_confirmation = "We should be confirmed"
    assert t.save
  end

  def test_validates_confirmation_of_for_ruby_class
    Person.validates_confirmation_of :karma

    p = Person.new
    p.karma_confirmation = "None"
    assert p.invalid?

    assert_equal ["doesn't match confirmation"], p.errors[:karma]

    p.karma = "None"
    assert p.valid?
  ensure
    Person.reset_callbacks(:validate)
  end

end
