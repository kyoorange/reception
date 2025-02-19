class RegistrantsController < ApplicationController
# 一覧表示につかう
def index
@registrants = Registrant.all
end
# 新規作成につかう
def create
end
# 検索などにつかう
def show
    number = params[:id]
    registrant = Registrant.find_by(number: number)

    if registrant
        render json: { name: registrant.name }
    else
        Rails.logger.error("会員番号 #{number} が見つかりませんでした")
        render json: { error: "Not Found" }, status: 404
    end
end
def home
@registrants = Registrant.all
end
def analytics
end
end
