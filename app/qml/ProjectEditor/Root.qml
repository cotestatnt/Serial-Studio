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

import SerialStudio

import "Views" as Views
import "Sections" as Sections
import "../Widgets" as Widgets

Window {
  id: root

  //
  // Window options
  //
  minimumWidth: 970
  minimumHeight: 640
  title: qsTr("%1 - Project Editor").arg(Cpp_Project_Model.title + (Cpp_Project_Model.modified ? " (" + qsTr("modified") + ")" : ""))

  //
  // Ask user to save changes when closing the dialog
  //
  onClosing: (close) => close.accepted = Cpp_Project_Model.askSave()

  //
  // Ensure that current JSON file is shown
  //
  onVisibleChanged: {
    if (visible) {
      Cpp_NativeWindow.addWindow(root)
      Cpp_Project_Model.openJsonFile(Cpp_JSON_Generator.jsonMapFilepath)
    }

    else
      Cpp_NativeWindow.removeWindow(root)
  }

  //
  // Dummy string to increase width of buttons
  //
  readonly property string _btSpacer: "  "

  //
  // Save window size
  //
  Settings {
    category: "ProjectEditor"
    property alias windowX: root.x
    property alias windowY: root.y
    property alias windowWidth: root.width
    property alias windowHeight: root.height
  }

  //
  // Shortcuts
  //
  Shortcut {
    sequences: [StandardKey.Open]
    onActivated: Cpp_Project_Model.openJsonFile()
  } Shortcut {
    sequences: [StandardKey.New]
    onActivated: Cpp_Project_Model.newJsonFile()
  } Shortcut {
    sequences: [StandardKey.Save]
    onActivated: Cpp_Project_Model.saveJsonFile()
  } Shortcut {
    sequences: [StandardKey.Close]
    onActivated: root.close()
  }

  //
  // Use page item to set application palette
  //
  Page {
    anchors.fill: parent
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

    ColumnLayout {
      id: layout
      spacing: 0
      anchors.fill: parent

      //
      // Toolbar
      //
      Sections.Toolbar {
        z: 2
        Layout.fillWidth: true
      }

      //
      // Main Layout
      //
      RowLayout {
        spacing: 0
        Layout.topMargin: -1
        Layout.fillWidth: true
        Layout.fillHeight: true

        //
        // Project structure
        //
        Sections.ProjectStructure {
          id: projectStructure
          Layout.fillHeight: true
          Layout.minimumWidth: 256
        }

        //
        // Panel border
        //
        Rectangle {
          z: 2
          width: 1
          Layout.fillHeight: true
          color: Cpp_ThemeManager.colors["setup_border"]

          Rectangle {
            width: 1
            height: 32
            anchors.top: parent.top
            anchors.left: parent.left
            color: Cpp_ThemeManager.colors["pane_caption_border"]
          }
        }

        //
        // Action view
        //
        Views.ActionView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          visible: Cpp_Project_Model.currentView === ProjectModel.ActionView
        }

        //
        // Project setup
        //
        Views.ProjectView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          visible: Cpp_Project_Model.currentView === ProjectModel.ProjectView
        }

        //
        // Group view
        //
        Views.GroupView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          visible: Cpp_Project_Model.currentView === ProjectModel.GroupView
        }

        //
        // Dataset view
        //
        Views.DatasetView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          visible: Cpp_Project_Model.currentView === ProjectModel.DatasetView
        }

        //
        // Frame parser function
        //
        Views.FrameParserView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          visible: Cpp_Project_Model.currentView === ProjectModel.FrameParserView
        }
      }
    }
  }
}
