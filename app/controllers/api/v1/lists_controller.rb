class Api::V1::ListsController < ApplicationController
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]
	respond_to :json

	def create
		list = current_user.lists.build(list_params)
		if list.save
			render json: list, status: 201, location: [:api, list]
		else
			render json: { errors: list.errors }, status: 422 
		end
	end

	def index
		respond_with List.all
	end

	def show
		respond_with List.find(params[:id])
	end

	def update
		begin
			list  = current_user.lists.find(params[:id])
			if list.update(list_params)
				render json: list, status: 200, location: [:api, list]
			else
				render json: { errors: list.errors }, status: 422
			end
		rescue ActiveRecord::RecordNotFound 
			render json: { errors: "data not found" }, status: 404
		end
	end
	
	def destroy
		begin
			list = current_user.lists.find(params[:id])
	    	list.destroy
	    	head 204
		rescue ActiveRecord::RecordNotFound 
			render json: { errors: "data not found" }, status: 404
		end
	end

	private
		def list_params
			params.require(:list).permit(:item)
		end
end
