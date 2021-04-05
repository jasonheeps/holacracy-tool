class AddNewElectionDateToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :new_election_date, :date
  end
end
