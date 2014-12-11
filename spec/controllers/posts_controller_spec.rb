require 'rails_helper'

describe PostsController do
  describe "GET 'index'" do
    context 'as a standard request' do
      before do
        get :index
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it { expect(assigns(:page)).to eql 0 }
    end
    context 'as an xhr request' do
      before do
        xhr :get, :index, p: '1'
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it { expect(assigns(:page)).to eql 1 }
      it "renders without a layout" do
        expect(response).not_to render_template 'application'
      end
    end
  end
end
