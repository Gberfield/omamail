import QtQuick 2.15
import QtTest 1.3
import qs.Commons
import "../../components" as Omamail
import "../../message/Html.js" as Html

// A right-click on the message body: Copy for what is selected, and Open and
// Copy URL when the click lands on a link.
Item {
  width: 900
  height: 800

  readonly property string senderHtml: '<p>Person 1 moved 4 cards.</p>'
    + '<p><a href="https://example.com/board">Open the board</a></p>'

  readonly property var rendered: Html.sanitize(senderHtml, ({ withReader: true }))

  QtObject {
    id: mailService

    property var copied: []
    property var opened: []

    property string selectedId: "message-9"
    property var selectedMessage: ({
      id: "message-9",
      subject: "Activity on Sprint board",
      from: ({ display: "Boards", email: "boards@example.com" }),
      to: [({ display: "Reader", email: "reader@example.com" })],
      fullTime: "Oct 22, 2026 16:02",
      starred: false
    })
    property bool detailLoading: false
    property bool detailPainted: true
    property bool selectedHasHtml: rendered.html !== ""
    property var selectedDocument: rendered.document
    property var selectedReaderDocument: rendered.reader.document
    property bool selectedReaderTooHeavy: rendered.reader.tooHeavy
    property bool selectedReaderEmpty: rendered.reader.empty
    property int selectedRemoteImages: rendered.remoteImages
    property bool remoteImagesAllowed: false
    property bool selectedTooHeavy: rendered.tooHeavy
    property string unsubscribeLabel: ""
    property string unsubscribeDetail: ""
    property bool unsubscribing: false
    property var selectedBody: ({ text: "Person 1 moved 4 cards.", source: "html" })
    property var selectedImages: []
    property var selectedInvite: null
    property string selectedResponse: ""
    property bool canRespondToInvite: false
    property bool rsvpSending: false
    property bool canArchive: true
    property bool canOpenOnWeb: false
    property var selectedAttachments: []

    function getMessage() {}
    function showRemoteImages() {}
    function copyText(text) { copied = copied.concat([String(text)]); return true }
    function openExternal(url) { opened = opened.concat([String(url)]); return true }
  }

  Omamail.MessageReader {
    id: reader
    width: 900
    height: 600
    service: mailService
    textColor: Qt.rgba(1, 1, 1, 1)
    backgroundColor: Qt.rgba(0.06, 0.06, 0.06, 1)
    accentColor: Qt.rgba(1, 0.5, 0, 1)
    linkColor: Qt.rgba(0.3, 0.7, 1, 1)
    dimColor: Qt.rgba(0.67, 0.67, 0.67, 1)
    popupBackgroundColor: Qt.rgba(0.13, 0.13, 0.13, 1)
    popupBorderColor: Qt.rgba(0.47, 0.47, 0.47, 1)
    leadingBoundaryOverlap: 0
    dimmerColor: Qt.rgba(0.47, 0.47, 0.47, 1)
    panelFontFamily: "monospace"
    bodyMode: "reader"
    onBodyModeRequested: function(mode) { reader.bodyMode = mode }
  }


  Omamail.MessageRow {
    id: row
    y: 600
    width: 600
    textColor: Qt.rgba(1,1,1,1)
    accentColor: Qt.rgba(1,0.5,0,1)
    dimColor: Qt.rgba(0.5,0.5,0.5,1)
    panelFontFamily: "monospace"
    summary: ({id:"one", subject:"Synthetic native summary", from:{display:"Sender"},
      snippet:"", time:"14:57", fullTime:"Oct 22, 2026 14:57", unread:false, starred:false})
  }
  Omamail.ConversationRail {
    id: rail
    x: 610
    y: 600
    width: 250
    height: 180
    stops: [{id:"one", known:true, open:true, sender:"Sender", time:"16:02", unread:false, flagged:false, mailbox:""}]
    caption: "1 message"
    textColor: Qt.rgba(1,1,1,1)
    backgroundColor: Qt.rgba(0,0,0,1)
    accentColor: Qt.rgba(1,0.5,0,1)
    dimColor: Qt.rgba(0.5,0.5,0.5,1)
    dimmerColor: Qt.rgba(0.5,0.5,0.5,1)
    panelFontFamily: "monospace"
  }
  TestCase {
    name: "NativeTwelveHourDisplay"
    when: windowShown
    function test_preformatted_backend_labels_are_converted_in_real_widgets() {
      waitForRendering(reader)
      compare(findChild(row, "message-time").text, "2:57 PM")
      var label = findChild(reader, "message-full-time")
      verify(label)
      verify(label.text.indexOf("Oct 22, 2026 4:02 PM") >= 0)
      compare(findChild(rail, "conversation-time").text, "4:02 PM")
      compare(mailService.selectedMessage.fullTime, "Oct 22, 2026 16:02", "the backend summary is not mutated")
    }
  }
}
