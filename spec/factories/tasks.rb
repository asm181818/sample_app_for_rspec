FactoryBot.define do
  factory :task do
    title { 'テストタイトル' }
    status { 'todo' }
    association :user
  end
end
