// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require bootstrap
//= require moment
//= require fullcalendar
//= require fullcalendar/lang/ja
//= require fullcalendar
//= require bootstrap-datetimepicker
//= require_tree .

document.addEventListener("turbolinks:load", function() {
  $('#calendar').fullCalendar({
    // ヘッダーのタイトルとボタン
    header: {
      left: "today month,agendaWeek historyInsButton",
      center: "title",
      right: "prev next"
    },
    defaultView: 'agendaWeek',

    events: function(start, end, timezone, callback) {
      var url = $("#pathname").val() + '/act_histories.json' ;
      var type = "get";

      $.ajax({
        url: url,
        type: type,
      }).done(function(data) {
        callback(data);
      }).fail(function(XMLHttpRequest, textStatus, errorThrown) {
        errorMsgShow(XMLHttpRequest);
        window.location.href = "/login";
      })
    },

    //カレンダーの高さ
    height: window.innerHeight - 200,
    windowResize: function () {
      $('#calendar').fullCalendar('option', 'height', window.innerHeight - 200);
    },

    //agendaWeekのオプション
    slotEventOverlap: false,
    allDaySlot: false,
    agendaEventMinHeight: 10,

    //入力フォームを表示するためのボタン
    customButtons: {
      historyInsButton: {
        text: 'アクティビティ履歴新規登録',
        // モーダルウインドウ表示
        click: function() {
          //モーダルウインドウ初期化する
          $("#inputActName").val("");
          $("#inputYmdFrom").val("");
          $("#inputHmFrom").val("");
          $("#inputYmdTo").val("");
          $("#inputHmTo").val("");
          $("#inputRemarks").val("");

          //更新前の値を隠し項目を初期化
          $('input:hidden[id="beforeActName"]').val("");
          $('input:hidden[id="beforeFromTime"]').val("");
          $('input:hidden[id="beforeToTime"]').val("");

          //更新・削除ボタンを非表示に
          $('#deleteButton').hide();
          $('#updateButton').hide();
          $('#createButton').show();

          modalShow();
        }
      },
    },
    //登録済みの行動履歴を確認
    eventClick: function(data) {
      var url = $("#pathname").val() + "/act_history/edit";
      var type = "post";
      var eventData = {
        title:  data.title,
        start:  moment(data.start).format("YYYY-MM-DD HH:mm"),
        end:    moment(data.end).format("YYYY-MM-DD HH:mm")
      };

      //更新前の値を隠し項目に設定
      $('input:hidden[id="beforeActName"]').val(eventData.title);
      $('input:hidden[id="beforeFromTime"]').val(eventData.start);
      $('input:hidden[id="beforeToTime"]').val(eventData.end);

      //登録ボタンを非表示に
      $('#deleteButton').show();
      $('#updateButton').show();
      $('#createButton').hide();

      //非同期通信対策
      ajaxConection(eventData, url, type).done(function(data) {
        $("#inputActName").val(data[0].activity_name);
        $("#inputYmdFrom").val(data[0].from_ymd);
        $("#inputHmFrom").val(data[0].from_hm);
        $("#inputYmdTo").val(data[0].to_ymd);
        $("#inputHmTo").val(data[0].to_hm);
        $("#inputRemarks").val(data[0].remarks);
      })

      modalShow();
    }
  });
});

/**
 * 行動履歴入力フォームの削除ボタンクリックイベント
 */
function deleteHistory() {
  var url = $("#pathname").val() + "/act_history";
  var type = "delete";
  var eventData = {
    before_act_name:  $('input:hidden[id="beforeActName"]').val(),
    before_from_time: $('input:hidden[id="beforeFromTime"]').val(),
    before_to_time: $('input:hidden[id="beforeToTime"]').val()
  };

  //非同期通信対策
  ajaxConection(eventData, url, type).done(function(data) {
    location.reload();
  }).fail(function(XMLHttpRequest, textStatus, errorThrown) {
    errorMsgShow(XMLHttpRequest);
    window.location.href = "/login";
  })
}

/**
 * 行動履歴入力フォームの更新ボタンクリックイベント
 */
function updateHistory() {
  var url = $("#pathname").val() + "/act_history";
  var type = "patch";
  var eventData = {
    activity_name:  $('#inputActName').val(),
    from_time:      $('#inputYmdFrom').val() + " " + $('#inputHmFrom').val(),
    to_time:        $('#inputYmdTo').val() + " " + $('#inputHmTo').val(),
    remarks:        $('#inputRemarks').val(),
    before_act_name:  $('input:hidden[id="beforeActName"]').val(),
    before_from_time: $('input:hidden[id="beforeFromTime"]').val(),
    before_to_time: $('input:hidden[id="beforeToTime"]').val()
  };

  //非同期通信対策
  ajaxConection(eventData, url, type).done(function(data) {
    location.reload();
  }).fail(function(XMLHttpRequest, textStatus, errorThrown) {
    messeges = errorMsgShow(XMLHttpRequest);
    if (messeges == "ログインしてください") {
      window.location.href = "/login";
    }
  })
}

/**
 * 行動履歴入力フォームの登録ボタンクリックイベント
 */
function createHistory() {
  var url = $("#pathname").val() + "/act_histories/new";
  var type = "post";
  var eventData = {
    activity_name:  $('#inputActName').val(),
    from_time:      $('#inputYmdFrom').val() + " " + $('#inputHmFrom').val(),
    to_time:        $('#inputYmdTo').val() + " " + $('#inputHmTo').val(),
    remarks:        $('#inputRemarks').val()
  };

  //非同期通信対策
  ajaxConection(eventData, url, type).done(function(data) {
    location.reload();
  }).fail(function(XMLHttpRequest, textStatus, errorThrown) {
    messeges = errorMsgShow(XMLHttpRequest);
    if (messeges == "ログインしてください") {
      window.location.href = "/login";
    }
  })
}

/**
 * 入力フォームモーダルウィンドウ表示
 */
function modalShow() {
  $('#inputHistoryForm').on('show.bs.modal', function (event) {
    setTimeout(function(){
      $('#inputActName').focus();
    }, 500);
  }).modal("show");

  //日付ピッカー
  $('.ymd').datetimepicker({format : 'YYYY/MM/DD'});
  $('.hm').datetimepicker({format : 'HH:mm'});
}

/**
 * ajax通信
 */
function ajaxConection(eventData, url, type) {

  //RailsのCSRF対策
  $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
    var token;
    if (!options.crossDomain) {
      token = $('meta[name="csrf-token"]').attr('content');
      if (token) {
        return jqXHR.setRequestHeader('X-CSRF-Token', token);
      }
    }
  });

  return $.ajax({
    url: url,
    type: type,
    data: JSON.stringify(eventData)
  })
}

/**
 * 登録・更新時のエラーメッセージ表示
 */
function errorMsgShow(req) {
  var res = {}
  try {
    res = JSON.parse(req.responseText);
  } catch (e) {
  }

  res = res.toString().replace(/,/g,"\n");
  alert(res);
  return res;
}
