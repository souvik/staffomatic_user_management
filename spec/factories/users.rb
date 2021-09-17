FactoryBot.define do
  factory :user do
    email { 'john.doe@staffomatic.com' }
    password { 'supersecurepassword' }
  end

  factory :random_user, class: User, aliases: [:active_user] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :archived_user do
      status { 'archived' }
    end

    factory :deleted_user do
      status { 'deleted' }
    end
  end
end
