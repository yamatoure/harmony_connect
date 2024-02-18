require 'rails_helper'
describe MembersController, type: :request do

  before do
    @member = FactoryBot.create(:member)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get members_path
      expect(response.status).to eq 200
    end

    it 'indexアクションにリクエストするとレスポンスに登録済みのタイトルが存在する' do 
      get members_path
      expect(response.body).to include(@member.title)
    end

    it 'indexアクションにリクエストするとレスポンスに投稿検索チェックボックスが存在する' do 
      get members_path
      expect(response.body).to include('検索する')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get member_path(@member)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストするとレスポンスに登録済みのタイトルが存在する' do 
      get member_path(@member)
      expect(response.body).to include(@member.title)
    end

    it 'showアクションにリクエストするとレスポンスに登録済みの紹介文が存在する' do 
      get member_path(@member)
      expect(response.body).to include(@member.content)
    end

    it 'showアクションにリクエストするとレスポンスに登録済みの活動地域が存在する' do 
      get member_path(@member)
      expected_text = @member.areas.order(:area_id).map(&:area).join
      expect(response.body.gsub(/\s/,"")).to include(expected_text)
    end

    it 'showアクションにリクエストするとレスポンスに登録済みの希望パートが存在する' do 
      get member_path(@member)
      expected_text = @member.parts.order(:part_id).map(&:part).join
      expect(response.body.gsub(/\s/,"")).to include(expected_text)
    end

    it 'showアクションにリクエストするとレスポンスに登録者名が存在する' do 
      get member_path(@member)
      expect(response.body).to include(@member.user.name)
    end
  end
end
