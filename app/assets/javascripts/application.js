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
          document.getElementById("deleteButton").style.visibility = "hidden";
          document.getElementById("updateButton").style.visibility = "hidden";
          document.getElementById("createButton").style.visibility = "visible";

          modalShow();
        }
      },
    },
    // ヘッダーのタイトルとボタン
    header: {
      left: "today month,agendaWeek historyInsButton",
      center: "title",
      right: "prev next"
    },
    defaultView: 'agendaWeek',
    events: '/act_histories.json',

    //agendaWeekのオプション
    slotEventOverlap: false,
    allDaySlot: false,
    agendaEventMinHeight: 10,

    //登録済みの行動履歴を確認
    eventClick: function(data) {
      var url = "/act_history/edit";
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
      document.getElementById("deleteButton").style.visibility ="visible";
      document.getElementById("updateButton").style.visibility ="visible";
      document.getElementById("createButton").style.visibility ="hidden";

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
  var url = "/act_history";
  var type = "delete";
  var eventData = {
    before_act_name:  $('input:hidden[id="beforeActName"]').val(),
    before_from_time: $('input:hidden[id="beforeFromTime"]').val(),
    before_to_time: $('input:hidden[id="beforeToTime"]').val()
  };

  //非同期通信対策
  ajaxConection(eventData, url, type).done(function(data) {
    location.reload();
  })
}
/**
 * 行動履歴入力フォームの更新ボタンクリックイベント
 */
function updateHistory() {
  var url = "/act_history";
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
    errorMsgShow(XMLHttpRequest);
  })
}

/**
 * 行動履歴入力フォームの登録ボタンクリックイベント
 */
function createHistory() {
  var url = "/act_histories/new"
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
    errorMsgShow(XMLHttpRequest);
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
  $('.Hm').datetimepicker({format : 'HH:mm'});
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

  var messeges = "";
  Object.keys(res).forEach(function(key) {
    var val = this[key];
    switch (key) {
      case "activity_name":
        messeges += "アクティビティ名 : " + val + "\n";
        break;
      case "from_time":
        messeges += "開始日時 : " + val + "\n";
        break;
      case "to_time":
        messeges += "終了日時 : " + val + "\n";
        break;
      case "remarks":
        messeges += "備考 : " + val + "\n";
        break;
    }
    val = "";
  }, res);
  alert(messeges);
}
