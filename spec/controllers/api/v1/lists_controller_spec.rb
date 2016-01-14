require 'spec_helper'

describe Api::V1::ListsController do
	context "when is sucessfully created" do
		describe "POST #create" do
			before(:each) do
				user = FactoryGirl.create :user
				@list_attributes = FactoryGirl.attributes_for :list
				api_authorization_header user.auth_token
				post :create, {user_id: user.id, list: @list_attributes}
			end

			it "render the json reresentation for the list record just created" do
				list_response = json_response
				expect(list_response[:item]).to eql @list_attributes[:item]
			end

			context "when is not created" do
				before(:each) do
					user = FactoryGirl.create :user
					@invali_list_attributes = { item: "" }

					api_authorization_header user.auth_token
					post :create, { user_id: user.id, list: @invali_list_attributes}
				end

				it "renders error json" do
					list_response = json_response
					expect(list_response).to have_key(:errors)
				end

				it "renders the json errors on why the user could not be created" do
					list_response = json_response
					expect(list_response[:errors][:item]).to include "can't be blank"
				end

				it { should respond_with 422 }
			end
		end

		describe "PUT #update" do
			before(:each) do
				@user = FactoryGirl.create :user
				@list = FactoryGirl.create :list, user:@user
				api_authorization_header @user.auth_token
			end

			context "when is sucessfully updated" do
				before(:each) do
					patch :update, { user_id: @user.id, id: @list.id, list: {item: "todo list test"} }
				end

				it "renders the json representation for update user" do
					list_response = json_response
					expect(list_response[:item]).to eql "todo list test"
				end

				it { should respond_with 200 }
			end

			context "when is no updated" do
				before(:each) do
					patch :update, { user_id: @user.id, id: @list.id, list: { item: "" } }
				end

				it "renders the json errors on why the user could not e updated" do
					list_response = json_response
					expect(list_response[:errors][:item]).to include "can't be blank"
				end

				it { should respond_with 422 }
			end

			describe "DELETE #destroy" do
				before(:each) do
					@user = FactoryGirl.create :user
					@list = FactoryGirl.create :list, user: @user
					api_authorization_header @user.auth_token
					delete :destroy, {user_id: @user.id, id: @list.id}
				end

				it { should respond_with 204 }
			end
		end
	end
end
