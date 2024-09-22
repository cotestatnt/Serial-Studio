/*
 * Copyright (c) 2020-2023 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

Window {
  id: root

  //
  // Window options
  //
  title: qsTr("Donate")
  width: minimumWidth
  height: minimumHeight
  x: (Screen.desktopAvailableWidth - width) / 2
  y: (Screen.desktopAvailableHeight - height) / 2
  minimumWidth: column.implicitWidth + root.titlebarHeight
  maximumWidth: column.implicitWidth + root.titlebarHeight
  minimumHeight: column.implicitHeight + root.titlebarHeight + 32
  maximumHeight: column.implicitHeight + root.titlebarHeight + 32

  //
  // Make window stay on top
  //
  Component.onCompleted: root.flags |= Qt.WindowStaysOnTopHint

  //
  // Native window registration
  //
  property real titlebarHeight: 0
  onVisibleChanged: {
    if (visible) {
      Cpp_NativeWindow.addWindow(root)
      root.titlebarHeight = Cpp_NativeWindow.titlebarHeight(root)
    }

    else {
      root.titlebarHeight = 0
      Cpp_NativeWindow.removeWindow(root)
    }
  }

  //
  // Background + window title on macOS
  //
  Rectangle {
    anchors.fill: parent
    color: Cpp_ThemeManager.colors["window"]

    //
    // Drag the window anywhere
    //
    DragHandler {
      target: null
      onActiveChanged: {
        if (active)
          root.startSystemMove()
      }
    }

    //
    // Titlebar text
    //
    Label {
      text: root.title
      visible: root.titlebarHeight > 0
      color: Cpp_ThemeManager.colors["titlebar_text"]
      font: Cpp_Misc_CommonFonts.customUiFont(13, true)

      anchors {
        topMargin: 6
        top: parent.top
        horizontalCenter: parent.horizontalCenter
      }
    }
  }

  //
  // Close shortcut
  //
  Shortcut {
    sequences: [StandardKey.Close]
    onActivated: root.close()
  }

  //
  // Custom properties
  //
  property alias doNotShowAgain: doNotShowAgainCheck.checked

  //
  // Enables the "do not show again" checkbox and sets
  // the text of the close button to "later".
  //
  // This is used when the window is shown automatically
  // every now and then to the user.
  //
  function showAutomatically() {
    doNotShowAgainCheck.visible = true
    closeBt.text = qsTr("Later")
    showNormal()
  }

  //
  // Disables the "do not show again" checkbox and sets
  // the text of the close button to "close".
  //
  // This is used when the user opens this dialog from
  // the "about" window.
  //
  function show() {
    doNotShowAgainCheck.visible = false
    closeBt.text = qsTr("Close")
    showNormal()
  }

  //
  // Save settings
  //
  Settings {
    property alias disableDonationsWindow: root.doNotShowAgain
  }

  //
  // Use page item to set application palette
  //
  Page {
    anchors.fill: parent
    anchors.topMargin: root.titlebarHeight
    palette.mid: Cpp_ThemeManager.colors["mid"]
    palette.dark: Cpp_ThemeManager.colors["dark"]
    palette.text: Cpp_ThemeManager.colors["text"]
    palette.base: Cpp_ThemeManager.colors["base"]
    palette.link: Cpp_ThemeManager.colors["link"]
    palette.light: Cpp_ThemeManager.colors["light"]
    palette.window: Cpp_ThemeManager.colors["window"]
    palette.shadow: Cpp_ThemeManager.colors["shadow"]
    palette.accent: Cpp_ThemeManager.colors["accent"]
    palette.button: Cpp_ThemeManager.colors["button"]
    palette.midlight: Cpp_ThemeManager.colors["midlight"]
    palette.highlight: Cpp_ThemeManager.colors["highlight"]
    palette.windowText: Cpp_ThemeManager.colors["window_text"]
    palette.brightText: Cpp_ThemeManager.colors["bright_text"]
    palette.buttonText: Cpp_ThemeManager.colors["button_text"]
    palette.toolTipBase: Cpp_ThemeManager.colors["tooltip_base"]
    palette.toolTipText: Cpp_ThemeManager.colors["tooltip_text"]
    palette.linkVisited: Cpp_ThemeManager.colors["link_visited"]
    palette.alternateBase: Cpp_ThemeManager.colors["alternate_base"]
    palette.placeholderText: Cpp_ThemeManager.colors["placeholder_text"]
    palette.highlightedText: Cpp_ThemeManager.colors["highlighted_text"]

    //
    // Window controls
    //
    ColumnLayout {
      id: column
      spacing: 16
      anchors.centerIn: parent

      RowLayout {
        spacing: 16
        Layout.fillWidth: true
        Layout.fillHeight: true

        Image {
          sourceSize: Qt.size(120, 120)
          Layout.alignment: Qt.AlignVCenter
          source: "qrc:/rcc/images/donate-qr.svg"

          Rectangle {
            border.width: 2
            color: "transparent"
            anchors.fill: parent
            border.color: "#000"
          }
        }

        ColumnLayout {
          spacing: 4
          Layout.fillWidth: true
          Layout.fillHeight: true

          Item {
            Layout.fillHeight: true
          }

          Label {
            id: title
            Layout.fillWidth: true
            Layout.minimumHeight: font.pixelSize
            font: Cpp_Misc_CommonFonts.customUiFont(16, true)
            text: qsTr("Support the development of %1!").arg(Cpp_AppName)
          }

          Label {
            Layout.fillWidth: true
            Layout.minimumHeight: font.pixelSize * 3
            Layout.maximumWidth: title.implicitWidth
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            text: qsTr("Serial Studio is free & open-source software supported by volunteers. " +
                       "Consider donating to support development efforts :)")
          }

          Label {
            opacity: 0.8
            font.pixelSize: 12
            Layout.fillWidth: true
            Layout.minimumHeight: font.pixelSize * 2
            Layout.maximumWidth: title.implicitWidth
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            text: qsTr("You can also support this project by sharing it, reporting bugs and proposing new features!")
          }

          Item {
            Layout.fillHeight: true
          }
        }
      }

      RowLayout {
        spacing: 4
        Layout.fillWidth: true

        CheckBox {
          Layout.leftMargin: -6
          id: doNotShowAgainCheck
          Layout.alignment: Qt.AlignVCenter
          text: qsTr("Don't annoy me again!")
        }

        Item {
          Layout.fillWidth: true
        }

        Button {
          id: closeBt
          onClicked: root.close()
          Layout.alignment: Qt.AlignVCenter
        }

        Button {
          highlighted: true
          text: qsTr("Donate")
          Keys.onEnterPressed: clicked()
          Keys.onReturnPressed: clicked()
          Layout.alignment: Qt.AlignVCenter
          Component.onCompleted: forceActiveFocus()
          onClicked: Qt.openUrlExternally("https://www.paypal.com/donate?hosted_button_id=XN68J47QJKYDE")
        }
      }
    }
  }
}
