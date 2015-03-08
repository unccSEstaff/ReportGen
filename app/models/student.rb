class Student < ActiveRecord::Base
	validate :name, :niner_net, presence: true
end
