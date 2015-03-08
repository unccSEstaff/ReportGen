class AddCh4WalkthroughToStudents < ActiveRecord::Migration
  def change
    add_column :students, :github_username, :string
    add_column :students, :ch4_repo_name, :string
  end
end
