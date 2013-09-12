#coding=utf-8
class DataFormsController < ApplicationController
  autocomplete :firework, :name, :display_value => :name_spec, :full => true, :extra_data => [:lastdata,:spec]

  def index
  	@data_forms = DataForm.order("created_at DESC").
  	          page(params[:page]||1).per(20)
  end

  def new
  	@data_form = DataForm.new
    @type = params[:type]
  end

  def create
  	@data_form = DataForm.new(data_form_params)
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

  private
  def data_form_params
    params.require(:data_form).permit(:comment, :s_type, :state)
  end

end
