# -*- coding: utf-8 -*-
class Admin::SmsController < AdminController
  def index
    unless params[:keyword].blank?
      @sms_records = SmsRecord.where('has_sent = ?', params[:keyword])
                   .order('id DESC').page(params[:page]).per(100)
    else
      @sms_records = SmsRecord.where('id >= 1')
                   .order('id DESC').page(params[:page]).per(100)
    end


  end

  def new
    @sms_record = SmsRecord.new
    @selected_sms_users = SelectedSmsUsers.where('id >= 1')
                          .order('user_id DESC').page(params[:page]).per(100)
  end


  def create
    content = params[:content].strip

    if params[:send_type].to_i == 1 then
      users = SelectedSmsUsers.all
      users.each do |u|
        sms_record = SmsRecord.create(:user_id => u.user_id, :content => content)
        unless sms_record.nil?
          next if u.user.phone.blank?
          sent_result = SMS3.sendto u.user.phone, "#{content}"
          if sent_result
            sms_record.has_sent = true
            sms_record.save
          end
        end
      end
      flash[:sent] = true
    else
      users = User.where('has_subscribed_sms = ?', true)
      users.each do |u|
        sms_record = SmsRecord.create(:user_id => u.id, :content => content)
        unless sms_record.nil?
          next if u.phone.blank?
          sent_result = SMS3.sendto u.phone, "#{content}"
          if sent_result
            sms_record.has_sent = true
            sms_record.save
          end
        end
      end
      flash[:sent] = true
    end

    redirect_to admin_sms_path
  end


  # 清空所选用户
  def clear_selected
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE selected_sms_users")
    redirect_to :back
  end

end
