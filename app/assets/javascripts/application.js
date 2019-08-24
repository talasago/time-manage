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

//document.addEventListener('DOMContentLoaded', function() {
//  var calendarEl = document.getElementById('calendar');
//
//  var calendar = $("#calendar").fullCalendar(calendarEl, {
//    defaultView: 'basicWeek',
//    header: {
//      left: "today month,basicWeek",
//      center: "title",
//      right: "prev next"
//    },
//    editable: true, // イベントを編集するか
//    allDaySlot: false, // 終日表示の枠を表示するか
//    eventDurationEditable: false, // イベント期間をドラッグしで変更するかどうか
//    slotEventOverlap: false, // イベントを重ねて表示するか
//    selectable: true,
//    selectHelper: true,
//
//  });
//});

document.addEventListener('DOMContentLoaded', function() {
  $('#calendar').fullCalendar({
    //入力フォームを表示するためのボタン
    customButtons: {
      eventInsButton: {
        text: '新規行動履歴登録',
        click: function() {
           // タイトル初期化
           $("#inputTitle").val("");
           $('#inputScheduleForm').on('show.bs.modal', function (event) {
               setTimeout(function(){
                   $('#inputTitle').focus();
               }, 500);
           }).modal("show");

           $('#inputYmdFrom').datetimepicker({locale: 'ja', format : 'YYYY年MM月DD日', useCurrent: false });

        }

      }
    },
    // ヘッダーのタイトルとボタン
    header: {
      // title, pre v, next, prevYear, nextYear, today
      left: "today month,basicWeek eventInsButton",
      center: "title",
      right: "prev next"
    },
    defaultView: 'agendaWeek'
  });
  // 動的にオプションを変更する
  //$('#calendar').fullCalendar('option', 'height', 700);

  // カレンダーをレンダリング。表示切替時などに使用
  //$('#calendar').fullCalendar('render');

  // カレンダーを破棄（イベントハンドラや内部データも破棄する）
  //$('#calendar').fullCalendar('destroy')
});