import React from "react"
import PropTypes from "prop-types"

import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'

class StaticPagesHome extends React.Component {
  render () {
    return (
    <div class="center jumbotron">
      <FullCalendar defaultView="dayGridMonth" plugins={[ dayGridPlugin ]} />

      <h1>時間管理webアプリ</h1>
      <h2>
        自身がどのくらいの時間に何をしているかを管理するアプリです。時間は有限です！自分が何をしているか確認して改善しより良い人生を歩みましょう！
      </h2>
      登録ボタン
    </div>
    );
  }
}

export default StaticPagesHome
