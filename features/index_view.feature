Feature: 首页视图
  首页显示需要信息

  Scenario: 游客浏览
    Given 我没有登录
    Then 我应该看到宣传信息
    Then 我应该看到会员数量

  Scenario: 会员浏览
    Given 一个已经登录的用户
    Then 我应该看到我的名字
    When 我移动鼠标到我的名字上
    Then 我应该看到小导航栏上我的气场
