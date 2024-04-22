# frozen_string_literal: true

class AddAdminFlagToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin_flag, :boolean
  end
end
