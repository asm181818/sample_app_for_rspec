require 'rails_helper'

RSpec.describe Task, type: :model do
  # Taskクラスのバリデーションに関するテスト
  describe 'taskモデルのバリデーション' do
    it 'タイトル、ステータスが入っていれば有効' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'タイトルが入っていなければ無効' do
      # タイトルが空のタスクを作ろうとする
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータスが入っていなければ無効' do
      # ステータスが空のタスクを作ろうとする
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'タイトルが重複していると無効' do
      # タイトルが'test'のタスクを作成
      task = FactoryBot.create(:task, title: 'test')
      # 直前で生成したタスクと同じタイトル名のタスクを作ろうとする
      duplicated_title_task = FactoryBot.build(:task, title: 'test')
      duplicated_title_task.valid?
      expect(duplicated_title_task.errors[:title]).to include("has already been taken")
    end
  end
end

