# -*- coding: utf-8 -*-
Then /^我应该看到登出的消息$/ do
  page.should have_content '退出成功.'
end
