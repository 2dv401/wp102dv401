class AddConfirmedAtOnAll < ActiveRecord::Migration
  def change
    # To avoid a short time window between running the migration and updating all existing
    # users as confirmed, do the following
    User.update_all ["confirmed_at = ?", Time.now]
    # All existing user accounts should be able to log in after this.
  end

  def down
  end
end
