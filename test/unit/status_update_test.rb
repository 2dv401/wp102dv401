require 'test_helper'

class StatusUpdateTest < ActiveSupport::TestCase

# Testa så det inte går att spara en statusuppdatering utan innehåll
  test "should not save statusUpdate without content" do
    status = StatusUpdate.new(:content => "", :map_id => 1, :user_id => 1)
    assert !status.save,
           "Saved the statusUpdate without a content"
  end

# Testa så det inte går att spara en statusuppdatering utan att en användare är inkopplad
  test "should not save statusUpdate without user_id" do
    status = StatusUpdate.new(:content => "test", :map_id => 1)
    assert !status.save,
           "Saved the statusUpdate without a user_id"
  end

# Testa så det inte går att spara en statusuppdatering utan att en karta är inkopplad
  test "should not save statusUpdate without map_id" do
    status = StatusUpdate.new(:content => "test", :user_id => 1)
    assert !status.save,
           "Saved the statusUpdate without a map_id"
  end

# Testa så det går att ta bort en statusuppdatering
  test "should remove statusUpdate" do
    status = StatusUpdate.new(:content => "test", :map_id => 1, :user_id => 1)
    status.destroy
    assert status.destroyed?,
           "Didn't remove statusUpdate"
  end

# Testa så att bara ägaren kan ta bort en statusuppdatering

# Testa så att det går att ändra en statusuppdatering
  test "should be able to change existing status" do
    status = StatusUpdate.new(:content => "test status", :map_id => 1, :user_id => 1)
    content = "changed status"
    status.content = content
    assert_equal status.content,
                 "changed status",
                 "Status didn't change"
  end

# Testa så att felmeddelanden fungerar
  test "should show correct errormessage" do
    status = StatusUpdate.new(:content => "test", :map_id => 1, :user_id => 1)

    message = "En karta maste vara kopplad till statusen"
    status.map_id = nil
    assert status.invalid?
    assert_equal [message],
                 status.errors[:map_id],
                 "Incorrect error-message for map_id blank"

    message = "En anvandare maste vara kopplad till statusen"
    status.user_id = nil
    assert status.invalid?
    assert_equal [message],
                 status.errors[:user_id],
                 "Incorrect error-message for user_id blank"

    message = "Det gar inte att ladda upp en tom status."
    status.content = ""
    assert status.invalid?
    assert_equal [message],
                 status.errors[:content],
                 "Incorrect error-message for status blank"

    message = "Statusen for lang, korta ner din status och forsok igen."
    status.content = "test"
    assert status.invalid?
    assert_equal [message],
                 status.errors[:content],
                 "Incorrect error-message for status too_long"
  end
end
