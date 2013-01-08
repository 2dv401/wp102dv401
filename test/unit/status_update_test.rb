require 'test_helper'

class StatusUpdateTest < ActiveSupport::TestCase

 # Testa så det inte går att spara en statusuppdatering utan innehåll
  test "should not save statusUpdate without content" do
    statusUpdate = StatusUpdate.new
    assert !statusUpdate.save, "Saved the statusUpdate without a content"
  end

end
