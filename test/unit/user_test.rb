require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)

	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:rex).profile_name
		# user.email = "rhuxford@gmail.com"
		# user.first_name = "Rex"
		# user.last_name = "Huxford"
		# user.password = "password"
		# user.password_confirmation = "password"
		
		# users(:rex)
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do
		user = User.new(first_name: 'Rexy', last_name: 'Huxfords', email: "rhuxford2@gmail.com")
		user.password = user.password_confirmation = 'asdfasdf'
		
		user.profile_name = "My Profile With Spaces"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("Must be formatted correctly.")
	end

	test "a user can have a correctly formatted" do
		user = User.new(first_name: 'Rexy', last_name: 'Huxfords', email: "rhuxford2@gmail.com")
		user.password = user.password_confirmation = 'asdfasdf'

		user.profile_name = 'rexhuxford_1'
		assert user.valid?
	end

	test "that no error is raised when trying to access a friend list" do
		assert_nothing_raised do
			users(:rex).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:rex).friends << users(:mike)
		users(:rex).friends.reload
		assert users(:rex).friends.include?(users(:mike))
	end

	test "that creating a friendship based on user id and friend id works" do
		UserFriendship.create user_id: users(:rex).id, friend_id: users(:mike).id
		assert users(:rex).friends.include?(users(:mike))
	end
end