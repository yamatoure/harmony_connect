require 'rails_helper'

RSpec.describe Group, type: :model do
  before do
    @group = FactoryBot.build(:group)
  end

  describe 'メンバー募集の保存' do
    context 'メンバー募集が投稿できる場合' do
      it '全項目入力で投稿できる' do
        expect(@group).to be_valid
      end

      it '募集内容が空でも投稿できる' do
        @group.content = ''
        expect(@group).to be_valid
      end
    end

    context 'メンバー募集が投稿できない場合' do
      it 'タイトルが空では投稿できない' do
        @group.title = ''
        @group.valid?
        expect(@group.errors.full_messages).to include("Title can't be blank")
      end

      it '活動地域が空では投稿できない' do
        @group.areas = []
        @group.valid?
        expect(@group.errors.full_messages).to include("Area ids can't be blank")
      end

      it '募集パートが空では投稿できない' do
        @group.parts = []
        @group.valid?
        expect(@group.errors.full_messages).to include("Part ids can't be blank")
      end
      
      it 'ユーザーが紐付いていなければ投稿できない' do
        @group.user = nil
        @group.valid?
        expect(@group.errors.full_messages).to include("User must exist")
      end
    end
  end
end
