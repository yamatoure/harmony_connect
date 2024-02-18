require 'rails_helper'

RSpec.describe '参加希望登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @member_title = Faker::Lorem.sentence
    @member_content = Faker::Lorem.sentence
  end
  context '参加希望登録ができるとき'do
    it 'ログインしたユーザーは新規登録できる' do
      # ログインする
      sign_in(@user)
      # 参加希望登録ページへのボタンがあることを確認する
      expect(page).to have_content('参加希望を登録する')
      # 参加希望登録ページに移動する
      visit new_member_path
      # フォームに情報を入力する
      fill_in 'タイトル', with: @member_title
      fill_in '紹介文', with: @member_content
      member_area_check
      member_part_check
      # 送信するとMemberモデルのカウントが1上がることを確認する
      expect {
        click_on('登録する')
        sleep 1
      }.to change { Member.count }.by(1)
      # 参加希望者一覧ページに先ほど登録した内容の掲示が存在することを確認する（タイトル）
      expect(page).to have_content(@member_title)
    end
  end
  context '参加希望登録ができないとき'do
    it 'ログインしていないと参加希望登録ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # メンバー募集投稿ページのボタンをクリックするとログインページに遷移することを確認する
      click_on('参加希望を登録する')
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

RSpec.describe '参加希望編集', type: :system do
  before do
    @member1 = FactoryBot.create(:member)
    @member2 = FactoryBot.create(:member)
  end
  context '参加希望編集ができるとき' do
    it 'ログインしたユーザーは自分が登録した参加希望の編集ができる' do
      # 参加希望1を登録したユーザーでログインする
      sign_in(@member1.user)
      # 参加希望者一覧ページに遷移する
      visit members_path
      # 参加希望1の詳細ページに遷移する
      visit member_path(@member1)
      # 参加希望1に「編集」へのリンクがあることを確認する
      expect(page).to have_content('編集する')
      # 編集ページへ遷移する
      visit edit_member_path(@member1)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('member_title', with: @member1.title)
      expect(page).to have_field('member_content', with: @member1.content)
      # すでに登録済みの活動地域の内容がチェックボックスに選択されていることを確認する
      selected_area_checkboxes = all('input[name="member[area_ids][]"]:checked')
      selected_area_checkboxes.each do |checkbox|
        label = find("label[for='#{checkbox[:id]}']")
        expect(page).to have_checked_field(label.text)
      end
      # すでに登録済みの希望パートの内容がチェックボックスに選択されていることを確認する
      selected_part_checkboxes = all('input[name="member[part_ids][]"]:checked')
      selected_part_checkboxes.each do |checkbox|
        label = find("label[for='#{checkbox[:id]}']")
        expect(page).to have_checked_field(label.text)
      end
      # チェックボックスを全て外す
      checkboxes = all('input[type="checkbox"]')
      checkboxes.each do |checkbox|
        checkbox.uncheck
      end
      # フォームの登録内容を編集する
      fill_in 'member_title',with: "#{@member1.title}+編集したタイトル"
      fill_in 'member_content',with: "#{@member1.content}+編集した内容"
      member_area_check
      member_part_check
      # 編集してもMemberモデルのカウントは変わらないことを確認する
      expect{
        click_on('更新する')
        sleep 1
      }.to change { Member.count }.by(0)
      # 参加希望者一覧ページに先ほど変更した内容の掲示が存在することを確認する（タイトル）
      expect(page).to have_content("#{@member1_title}+編集したタイトル")
    end
  end
  context '参加希望編集ができないとき' do
    it 'ログインしたユーザーは自分以外が登録した参加希望の編集画面には遷移できない' do
      # 参加希望1を登録したユーザーでログインする
      sign_in(@member1.user)
      # 参加希望者一覧ページに遷移する
      visit members_path
      # 参加希望2の詳細ページに遷移する
      visit member_path(@member2)
      # 参加希望2に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
    end
    it 'ログインしていないと参加希望の編集画面には遷移できない' do
      # 参加希望1の詳細ページに遷移する
      visit member_path(@member1)
      # 参加希望1の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
      # 参加希望2の詳細ページに遷移する
      visit member_path(@member2)
      # 参加希望2の詳細ページに「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集する')
    end
  end
end

RSpec.describe '参加希望削除', type: :system do
  before do
    @member1 = FactoryBot.create(:member)
    @member2 = FactoryBot.create(:member)
  end
  context '参加希望が削除ができるとき' do
    it 'ログインしたユーザーは自らが登録した参加希望の削除ができる' do
      # 参加希望1を登録したユーザーでログインする
      sign_in(@member1.user)
      # 参加希望1の詳細ページに遷移する
      visit member_path(@member1)
      # 参加希望1に「削除」へのリンクがあることを確認する
      expect(page).to have_content('削除する')
      # 登録を削除するとレコードの数が1減ることを確認する
      expect{
        click_on('削除する')
        sleep 1
      }.to change { Member.count }.by(-1)
      # 参加希望者一覧ページには参加希望1の内容が存在しないことを確認する（タイトル）
      expect(page).to have_no_content("#{@member1.title}")
    end
  end
  context '参加希望が削除ができないとき' do
    it 'ログインしたユーザーは自分以外が登録した参加希望の削除ができない' do
      # 参加希望1を登録したユーザーでログインする
      sign_in(@member1.user)
      # 参加希望2の詳細ページに遷移する
      visit member_path(@member2)
      # 参加希望2に「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
    end
    it 'ログインしていないと参加希望の削除ボタンがない' do
      # 参加希望1の詳細ページに遷移する
      visit member_path(@member1)
      # 参加希望1の詳細ページに「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
      # 参加希望2の詳細ページに遷移する
      visit member_path(@member2)
      # 参加希望2の詳細ページに「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('削除する')
    end
  end
end