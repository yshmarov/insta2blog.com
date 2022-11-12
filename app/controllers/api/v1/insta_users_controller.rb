module Api
  module V1
    class InstaUsersController < ApplicationController
      def index
        @insta_users = InstaUser.all
        respond_to do |format|
          format.json
        end
      end

      def show
        @insta_user = InstaUser.find(params[:id])
        respond_to do |format|
          format.json
        end
      end
    end
  end
end
