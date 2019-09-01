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

$(document).ready(function() {
  initializePage();
});

function initializePage() {
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
          $("inputRemarks").val("");

          $('#inputHistoryForm').on('show.bs.modal', function (event) {
            setTimeout(function(){
              $('#inputActName').focus();
            }, 500);
          }).modal("show");

          //日付ピッカー
          $('.ymd').datetimepicker({format : 'YYYY/MM/DD'});
          $('.Hm').datetimepicker({format : 'HH:mm'});
        }
      },
    },
    // ヘッダーのタイトルとボタン
    header: {
      left: "today month,basicWeek historyInsButton",
      center: "title testbutton",
      right: "prev next"
    },
    defaultView: 'agendaWeek',
    navLinks: true,
    selectable: true,
    selectHelper: true,

    events: '/act_histories.json'
  });
}

/**
 * 行動履歴入力フォームの登録ボタンクリックイベント
 */
function createHistory() {
  var eventData = {
    activity_name:  $('#inputActName').val(),
    from_time:      $('#inputYmdFrom').val() + " " + $('#inputHmFrom').val(),
    to_time:        $('#inputYmdTo').val() + " " + $('#inputHmTo').val(),
    remarks:        $('#inputRemarks').val()
  };


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

  $.ajax({
    url: "/act_histories/new",  //名前付きルートにしたい。
    type: "post",
    data: JSON.stringify(eventData)
  }).done(function(data) {
    //入力フォームを消す(agendaWeekを再表示する)
    location.reload();
  }).fail(function(XMLHttpRequest, textStatus, errorThrown) {
    alert("error");
    //エラー部分を赤くして、エラー内容を表示する
  })
}