# == Schema Information
#
# Table name: data_lists
#
#  id           :integer          not null, primary key
#  data_form_id :integer
#  firework_id  :integer
#  data_number  :integer
#  last_data    :integer
#  s_type       :integer
#  state        :integer          default(1)
#  created_at   :datetime
#  updated_at   :datetime
#  before_data  :integer
#

#coding=utf-8
class DataList < ActiveRecord::Base
  belongs_to :data_form
  belongs_to :firework

  validates_presence_of :firework_id,:s_type
  #attr_accessor :name, :spec

  validates :firework_id, :numericality => true
  validates :data_number, :numericality => true

  def get_type
	s_type == 2 ? "出库" : "入库"
  end

  def finished?
	state == 2
  end

  def finish!
	self.state = 2
  end
end
