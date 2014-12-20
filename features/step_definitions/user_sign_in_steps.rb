# -*- coding: utf-8 -*-
When /^访问登录页面$/ do
  visit sign_in_path
end

When /^我使用错误的(.*)来登录$/ do |field|
  case field
  when '邮箱'
    @current_user.email = ''
  when '密码'
    @current_user.password = ''
  else
    conflict!
  end
  step "登录"
end


# Then
Then /^我应该看到登录(.*)的消息$/ do |msg|
  case msg
  when '成功'
    page.should have_content '登录成功.'
  when '失败'
    page.should have_content '邮箱或密码错误'
  when '过'
    page.should have_content '您已经登录.'
  else
    conflict!
  end
end

Then /^我应该被转到(.*)$/ do |page|
  case page
  when '首页'
    current_path.should == root_path
  when '注册页'
    #current_path.should == sign_up_path
    current_path.should == new_user_session_path
  else
    conflict!
  end
end
