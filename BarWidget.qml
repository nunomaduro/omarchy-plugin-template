import QtQuick

Item {
  id: root

  property var bar: null
  property string moduleName: ""
  property var settings: null

  readonly property string label: root.setting("label", "Hello")
  readonly property string tooltip: root.setting("tooltip", "Omarchy plugin template")
  readonly property string clickCommand: root.setting("onClick", "")
  readonly property bool vertical: root.bar ? root.bar.vertical === true : false
  readonly property int barSize: root.bar ? Number(root.bar.barSize) : 26

  function setting(key: string, fallback: string): string {
    const value = root.settings ? root.settings[key] : undefined
    return value === undefined || value === null ? fallback : String(value)
  }

  implicitWidth: root.vertical ? root.barSize : labelText.implicitWidth + 15
  implicitHeight: root.vertical ? labelText.implicitHeight + 12 : root.barSize

  Text {
    id: labelText

    anchors.centerIn: parent
    color: root.bar ? root.bar.foreground : "white"
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 12
    text: root.label
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      if (root.bar && root.clickCommand)
        root.bar.run(root.clickCommand)
    }
    onEntered: {
      if (root.bar && root.tooltip)
        root.bar.showTooltip(root, root.tooltip)
    }
    onExited: {
      if (root.bar)
        root.bar.hideTooltip(root)
    }
  }
}
