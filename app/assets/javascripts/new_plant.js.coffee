$.fn.ready ->
  $('#copy').click (e) ->
    link = $('#invite-link').val()
    try
      window.clipboardData.setData("Text",link)
      alert("已复制链接")
    catch error
      alert("不支持你所使用的浏览器，请手动复制。")

  cityWin = $('#school_lists')
  loadingText = $('#school_lists .loading')
  clearCitys = ->
    $("#citys").html('')
  clearSchools = ->
    $("#school_items").html('')

  $('.close-btn').click (e) ->
    cityWin.fadeOut()
    e.preventDefault()

  $('#map .province').click (e) ->
    clearCitys()
    clearSchools()
    cityWin.fadeIn()

  $('#map .donated').on 'ajax:success', (e, data) ->
    loadingText.fadeOut()
    html = ''
    $(data).each (idx, item) ->
      html += "<a href='/donated_schools?city=" + item + "'class='city-item donated_city' data-method='get' data-remote='true' title='"+ item + "'>" + item + "</a>"
    $('#citys').html(html)
  $('#map .agent').on 'ajax:success', (e, data) ->
    loadingText.fadeOut()
    html = ''
    $(data).each (idx, item) ->
      html += "<a href='javascript:void(0);' class='city-item' title='"+ item + "'>" + item + "</a>"
    $('#citys').html(html)

  $(document).on 'ajax:beforeSend', '#citys .donated_city', (e,data) ->
    loadingText.fadeIn()

  $(document).on 'ajax:success', '#citys .city-item', (e,data) ->
    html = ''
    $(data).each (idx, item) ->
      html += "<a href='/about_us?donate_school="+ item + "#donate' class='school-item' target='_blank' title=我要给" + item + "捐赠>"+ item + "</a>"
    loadingText.fadeOut()
    $('#school_items').html(html)

  $('#rank-search .btn').click ->
    e = $('#rank-search').find('#form')
    if e.attr('data-show') != 'y'
      e.fadeIn()
      e.attr('data-show','y')
    else
      e.fadeOut()
      e.attr('data-show','n')
  # showShare = ->
  #   $('#share-content').fadeIn()
  # hideShare = ->
  #   $('#share-content').fadeOut()

  # $('#share-item').mouseover(showShare)

  # do hideShare
  # $('.np-support-link').click (e) ->
  #   btn = $(this)
  #   url = btn.attr('href')
  #   $.ajax
  #     url: url
  #     type: 'POST'
  #    .done (data) ->
  #     $('#nsp_count').html(data)
  #   e.preventDefault()
