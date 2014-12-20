# -*- coding: utf-8 -*-
# When
When /^我提交(.*)合法的数据注册$/ do |invalid, table|
  table.hashes.each do |hash|
    visit sign_up_path
    hash.each do |key, value|
      fill_in key, with: value
    end
    click_button "注册"
  end
end

When /^我没有提交(.*)注册$/ do |field|
  user = build(:user)
  case field
  when '邮箱'
    user.email = ''
  when '密码'
    user.password = ''
  when '确认密码'
    user.password_confirmation = ''
  when '手机'
    user.phone = ''
  end

  visit sign_up_path
  fill_in '邮箱', with: user.email
  fill_in '密码', with: user.password
  fill_in '确认密码', with: user.password_confirmation
  fill_in '手机', with: user.phone
  click_button '注册'
end

When /^我提交密码和确认密码不匹配注册$/ do
  password = build(:user).password

  visit sign_up_path
  fill_in '密码', with: password
  fill_in '确认密码', with: password + rand(1000).to_s
  click_button '注册'
end


# Then
Then /^我应该看到注册成功的消息$/ do
  page.should have_content '欢迎您！您已注册成功.'
end

Then /^我应该看到(.*)缺失的消息$/ do |field|
  page.should have_content field + " 不能为空字符"
end

Then /^我应该看到(.*)不合法的消息$/ do |field|
  page.should have_content field + " 是无效的"
end

Then /^我应该看到密码不匹配的消息$/ do
  page.should have_content "密码 与确认值不匹配"
end

Then /^我应该看到密码过短的消息$/ do
  page.should have_content "密码 过短"
end
