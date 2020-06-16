require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user: user) }

  describe 'ログイン前' do
    describe 'タスク新規登録' do
      context 'ログインしていない状態' do
        it '未ログイン状態ではタスク新規作成ができない' do
          # タスク新規作成ページに遷移
          visit new_task_path
          expect(page).to have_content 'Login required'
        end
      end
    end
    
    describe 'タスク編集' do
      context 'ログインしていない状態' do
        it '未ログイン状態ではタスク編集ができない' do
          # タスク編集ページに遷移
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
        end
      end
    end

    describe 'タスク詳細' do  
      context 'ログインしていない状態' do
        it 'タスクの詳細ページが表示される' do
          # タスク詳細ページに遷移
          visit task_path(task)
          expect(page).to have_content task.title
        end
      end
    end

    describe 'タスク一覧' do
      context 'ログインしていない状態' do
        it 'タスクの一覧ページが表示される' do
          # タスクインスタンスをまとめて３つ生成
          task_list = FactoryBot.create_list(:task, 3)
          # タスク一覧ページに遷移
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in(user) }

    describe 'タスク新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規登録が成功する' do
          # タスク新規作成画面に遷移
          visit new_task_path
          fill_in 'task[title]', with: 'テストタイトル'
          fill_in 'task[content]', with: '本文'
          select 'todo', from: status
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          # タイトルが未入力
          fill_in 'task[title]', with: ''
          select 'todo', from: status
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          # 既に存在しているタイトル(letで作られているデータ)を入力
          fill_in 'task[title]', with: task.title
          select 'todo', from: status
          click_button 'Create Task'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end
    
    describe 'タスク編集' do
      # ユーザーに紐づいたテストタスクを作成
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'task[title]', with: 'テストタイトル更新'
          select 'todo', from: status
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          # タイトルが未入力
          fill_in 'task[title]', with: ''
          select 'todo', from: status
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済のタイトルを使用' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          # 別のタスクを作成
          other_task = FactoryBot.create(:task)
          # 既に存在しているタイトルを使用
          fill_in 'task[title]', with: other_task.title
          select 'todo', from: status
          click_button 'Update Task'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスク削除' do
      # itが実行される前にデータを作成、保存
      let!(:task) { FactoryBot.create(:task, user: user) }
      it 'タスクの削除が成功する' do
        visit tasks_path
        click_link 'Destroy'
        # タスク消去の確認ポップアップページ
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
      end
    end

    describe '他のユーザーのタスク編集ページにアクセス' do
      # 別のユーザーを作成
      other_user = FactoryBot.create(:user)
      it '他ユーザーのタスク編集ページへのアクセスが失敗する' do
        # 別のユーザーのタスクを作成
        other_user_task = FactoryBot.create(:task, user: other_user)
        visit edit_task_path(other_user_task)
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end
end
