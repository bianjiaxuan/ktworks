# -*- coding: utf-8 -*-
Given /^一个(.*)存在的用户$/ do |invalid|
  @current_user = invalid.empty? ? create(:user) : build(:user)
end

Given /^我是一个管理员$/ do
  @current_user = create(:admin)
end

Given /^我没有登录$/ do
  visit sign_out_path
end

Given /^登录$/ do
  visit sign_in_path
  fill_in "邮箱", with: @current_user.email
  fill_in "密码", with: @current_user.password
  click_button("登录")
end

Given /^作为(.*)登录了$/ do |email|
  @current_user = User.first conditions: {email: email}
  step "登录"
  page.should have_content "登录成功."
end

Given /^一个已经登录的用户$/ do
  step "一个存在的用户"
  step "登录"
  page.should have_content "登录成功."
end

Given /^访问登出页面$/ do
  visit sign_out_path
end
