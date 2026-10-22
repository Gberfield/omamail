import QtQuick
import QtTest
import "../../calendar/Calendar.js" as Calendar

TestCase {
  name: "TwelveHourClock"
  function test_qt_display_and_editor_roundtrip() {
    var hours = [0, 1, 11, 12, 13, 23]
    var labels = ["12:05 AM", "1:05 AM", "11:05 AM", "12:05 PM", "1:05 PM", "11:05 PM"]
    for (var i = 0; i < hours.length; i++) {
      var date = new Date(2026, 9, 22, hours[i], 5)
      compare(Qt.formatTime(date, "h:mm AP"), labels[i])
      compare(Calendar.timeLabel(date.getTime()), labels[i])
      var range = Calendar.editorDateRange("2026-10-22", labels[i], "2026-10-23", labels[i], false)
      verify(range.ok)
      compare(range.startMs, date.getTime())
    }
  }
}
