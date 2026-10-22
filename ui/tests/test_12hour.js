const assert = require("assert")
const { load } = require("./load")
const mail = load("message/Message.js")
const invite = load("message/Calendar.js")
const calendar = load("calendar/Calendar.js")

for (const [hour, expected] of [[0,"12:05 AM"],[1,"1:05 AM"],[11,"11:05 AM"],
  [12,"12:05 PM"],[13,"1:05 PM"],[23,"11:05 PM"]]) {
  const date = new Date(2026, 9, 22, hour, 5)
  assert.ok(mail.fullTime(date).endsWith(" " + expected))
  assert.strictEqual(invite.clockOf(date.getTime(), false), expected)
  assert.strictEqual(calendar.timeLabel(date.getTime()), expected)
  const range = calendar.editorDateRange("2026-10-22", expected,
    "2026-10-23", expected, false)
  assert.strictEqual(range.ok, true)
  assert.strictEqual(range.startMs, date.getTime())
}
assert.strictEqual(calendar.editorDateRange("2026-10-22", "12:00 am",
  "2026-10-22", "12:00 PM", false).ok, true)
for (const invalid of ["0:30 AM", "13:00 PM", "12:60 PM", "12:00 XX"]) {
  assert.strictEqual(calendar.editorDateRange("2026-10-22", invalid,
    "2026-10-23", "1:00 PM", false).ok, false)
}
console.log("12-hour display and event-entry round trips: PASS")
