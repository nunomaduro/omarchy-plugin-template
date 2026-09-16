import QtQuick

QtObject {
  id: stub

  property color foreground: "#ffffff"
  property string fontFamily: "monospace"
  property bool vertical: false
  property int barSize: 26
  property var commands: []
  property var tooltips: []

  function run(command: string) {
    stub.commands = stub.commands.concat([command])
  }

  function showTooltip(target: var, text: string) {
    stub.tooltips = stub.tooltips.concat([text])
  }

  function hideTooltip(target: var) {
    stub.tooltips = []
  }
}
