#coding=utf-8
class DataFormsController < ApplicationController
  def index
  	@data_forms = DataForm.all(:order => "created_at DESC").paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def new
  	@data_form = DataForm.new
    @type = params[:type]
  end

  def create
  	@data_form = DataForm.new(params[:data_form])
  	if @data_form.save
  		redirect_to @data_form
  	else
  		render :new
  	end
  end

  def show
    @data_form = DataForm.find(params[:id])
    @data_list = DataList.new unless @data_form.finished?
  end

  def destroy
    data_form = DataForm.find(params[:id])
    data_form.destroy

    redirect_to data_forms_path
  end

end
