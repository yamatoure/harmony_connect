require 'rails_helper'

RSpec.describe 'メンバー募集投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group_title = Faker::Lorem.sentence
    @group_content = Faker::Lorem.sentence
  end
  context 'メンバー募集投稿ができるとき'do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # メンバー募集投稿ページへのボタンがあることを確認する
      expect(page).to have_content('メンバーを募集する')
      # メンバー募集投稿ページに移動する
      visit new_group_path
      # フォームに情報を入力する
      fill_in 'タイトル', with: @group_title
      fill_in '内容', with: @group_content
      group_area_check
      group_part_check
      # 送信するとGroupモデルのカウントが1上がることを確認する
      expect {
        click_on('掲載する')
        sleep 1
      }.to change { Group.count }.by(1)
      # メンバー募集一覧ページに先ほど投稿した内容の掲示が存在することを確認する（タイトル）
      expect(page).to have_content(@group_title)
    end
  end
  context 'メンバー募集投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # メンバー募集投稿ページのボタンをクリックするとログインページに遷移することを確認する
      click_on('メンバーを募集する')
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

RSpec.describe 'メンバー募集編集', type: :system do
  before do
    @group1 = FactoryBot.create(:group)
    @group2 = FactoryBot.create(:group)
  end
  context 'メンバー募集編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したメンバー募集の編集ができる' do
      # メンバー募集1を投稿したユーザーでログインする
      sign_in(@group1.user)
      # メンバー募集一覧ページに遷移する
      visit groups_path
      # メンバー募集1の詳細ページに遷移する
      visit group_path(@group1)
      # メンバー募集1に「編集」へのリンクがあることを確認する
      expect(page).to have_content('編集する')
      # 編集ページへ遷移する
      visit edit_group_path(@group1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('group_title', with: @group1.title)
      expect(page).to have_field('group_content', with: @group1.content)
      # すでに投稿済みの活動地域の内容がチェックボックスに選択されていることを確認する
      selected_area_checkboxes = all('input[name="group[area_ids][]"]:checked')
      selected_area_checkboxes.each do |checkbox|
        label = find("label[for='#{checkbox[:id]}']")
        expect(page).to have_checked_field(label.text)
      end
      # すでに投稿済みの募集パートの内容がチェックボックスに選択されていることを確認する
      selected_part_checkboxes = all('input[name="group[part_ids][]"]:checked')
      selected_part_checkboxes.each do |checkbox|
        label = find("label[for='#{checkbox[:id]}']")
        expect(page).to have_checked_field(label.text)
      end
      # チェックボックスを全て外す
      checkboxes = all('input[type="checkbox"]')
      checkboxes.each do |checkbox|
        checkbox.uncheck
      end
      # フォームの投稿内容を編集する
      fill_in 'group_title',with: "#{@group1.title}+編集したタイトル"
      fill_in 'group_content',with: "#{@group1.content}+編集した内容"
      group_area_check
      group_part_check
      # 編集してもGroupモデルのカウントは変わらないことを確認する
      expect{
        click_on('更新する')
        sleep 1
      }.to change { Group.count }.by(0)
      # メンバー募集一覧ページに先ほど変更した内容の掲示が存在することを確認する（タイトル）
      expect(page).to have_content("#{@group1_title}+編集したタイトル")
    end
  end
  context 'メンバー募集編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したメンバー募集の編集画面には遷移できない' do
      # メンバー募集1を投稿したユーザーでログインする
      sign_in(@group1.user)
      # メンバー募集一覧ページに遷移する
      visit groups_path
      # メンバー募集2の詳細ページに遷移する
      visit group_path(@group2)
      # メンバー募集2に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
    end
    it 'ログインしていないとメンバー募集の編集画面には遷移できない' do
      # メンバー募集1の詳細ページに遷移する
      visit group_path(@group1)
      # メンバー募集1の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
      # メンバー募集2の詳細ページに遷移する
      visit group_path(@group2)
      # メンバー募集2の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
    end
  end
end

RSpec.describe 'メンバー募集削除', type: :system do
  before do
    @group1 = FactoryBot.create(:group)
    @group2 = FactoryBot.create(:group)
  end
  context 'メンバー募集が削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したメンバー募集の削除ができる' do
      # メンバー募集1を投稿したユーザーでログインする
      sign_in(@group1.user)
      # メンバー募集1の詳細ページに遷移する
      visit group_path(@group1)
      # メンバー募集1に「削除」へのリンクがあることを確認する
      expect(page).to have_content('削除する')
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        click_on('削除する')
        sleep 1
      }.to change { Group.count }.by(-1)
      # メンバー募集一覧ページにはメンバー募集1の内容が存在しないことを確認する（タイトル）
      expect(page).to have_no_content("#{@group1.title}")
    end
  end
  context 'メンバー募集が削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したメンバー募集の削除ができない' do
      # メンバー募集1を投稿したユーザーでログインする
      sign_in(@group1.user)
      # メンバー募集2の詳細ページに遷移する
      visit group_path(@group2)
      # メンバー募集2に「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
    end
    it 'ログインしていないとメンバー募集の削除ボタンがない' do
      # メンバー募集1の詳細ページに遷移する
      visit group_path(@group1)
      # メンバー募集1の詳細ページに「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
      # メンバー募集2の詳細ページに遷移する
      visit group_path(@group2)
      # メンバー募集2の詳細ページに「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
    end
  end
end