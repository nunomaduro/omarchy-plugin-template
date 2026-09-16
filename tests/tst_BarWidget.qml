import QtQuick
import QtTest
import ".."

TestCase {
  id: testCase

  name: "BarWidget"
  when: windowShown
  visible: true
  width: 200
  height: 60

  Component {
    id: widget

    BarWidget {}
  }

  Component {
    id: stubBar

    StubBar {}
  }

  function test_label_falls_back_when_no_setting_is_present() {
    const instance = createTemporaryObject(widget, testCase)
    compare(instance.label, "Hello")
    compare(instance.tooltip, "Omarchy plugin template")
    compare(instance.clickCommand, "")
  }

  function test_label_reads_the_setting() {
    const instance = createTemporaryObject(widget, testCase, {
      settings: {
        label: "Omarchy"
      }
    })
    compare(instance.label, "Omarchy")
  }

  function test_widget_takes_the_bar_size_across_the_bar() {
    const bar = createTemporaryObject(stubBar, testCase, {
      barSize: 30
    })
    const instance = createTemporaryObject(widget, testCase, {
      bar: bar
    })
    compare(instance.implicitHeight, 30)

    bar.vertical = true
    compare(instance.implicitWidth, 30)
  }

  function test_click_runs_the_command_of_the_setting() {
    const bar = createTemporaryObject(stubBar, testCase)
    const instance = createTemporaryObject(widget, testCase, {
      bar: bar,
      settings: {
        onClick: "omarchy-launch-browser"
      }
    })
    instance.width = instance.implicitWidth
    instance.height = instance.implicitHeight
    mouseClick(instance)
    compare(bar.commands, ["omarchy-launch-browser"])
  }

  function test_hover_shows_the_tooltip_of_the_setting() {
    const bar = createTemporaryObject(stubBar, testCase)
    const instance = createTemporaryObject(widget, testCase, {
      bar: bar,
      settings: {
        tooltip: "Say hello"
      }
    })
    instance.width = instance.implicitWidth
    instance.height = instance.implicitHeight
    mouseMove(instance, 1, 1)
    compare(bar.tooltips, ["Say hello"])
  }
}
