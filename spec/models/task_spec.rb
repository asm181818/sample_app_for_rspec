require 'rails_helper'

RSpec.describe Task, type: :model do
  # Taskクラスのバリデーションに関するテスト
  describe 'taskモデルのバリデーション' do
    it 'タイトル、ステータスが入っていれば有効' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'タイトルが入っていなければ無効' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータスが入っていなければ無効' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'タイトルが重複していると無効' do
      task1 = FactoryBot.create(:task)
      task2 = FactoryBot.build(:task)
      task2.valid?
      expect(task2.errors[:title]).to include("has already been taken")
    end
  end
end

