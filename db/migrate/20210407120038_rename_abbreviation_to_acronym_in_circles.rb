class RenameAbbreviationToAcronymInCircles < ActiveRecord::Migration[6.0]
  def change
    rename_column :circles, :abbreviation, :acronym
  end
end
