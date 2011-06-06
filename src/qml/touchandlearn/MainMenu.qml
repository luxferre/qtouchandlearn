 /*
    Touch'n'learn - Fun and easy mobile lessons for kids
    Copyright (C) 2010 by Alessandro Portale
    http://touchandlearn.sourceforge.net

    This file is part of Touch'n'learn

    Touch'n'learn is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Touch'n'learn is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Touch'n'learn; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

import Qt 4.7
import "database.js" as Database

Rectangle {
    width: 360
    height: 640
    id: mainWindow
    color: "#000"

    function handleVolumeChange(volume)
    {
        if (Database.volumeDisplay === null)
            Database.volumeDisplay = Qt.createQmlObject("import Qt 4.7; VolumeDisplay { width: " + mainWindow.width + "; height: " + mainWindow.height + "; anchors.fill: parent; }", mainWindow);
        Database.volumeDisplay.volume = volume;
        Database.volumeDisplay.displayVolume();
    }

    Connections {
        target: stage.item
        id: connection
        ignoreUnknownSignals: true
        onSelectedLessonChanged: switchToScreen(stage.item.selectedLesson)
        onClosePressed: switchToScreen("LessonMenu")
    }

    Rectangle {
        anchors.fill: parent
        id: courtain
        color: "#000"
        opacity: 1
        z: 1
    }

    Loader {
        id: stage
        anchors.fill: parent
        onLoaded: {
            screenBlendIn.start();
        }
    }

    function switchToScreen(screen)
    {
        Database.lessonData = null;
        Database.currentScreen = screen + '.qml';
        if (stage.source == '')
            stage.source = Database.currentScreen;
        else
            screenBlendOut.start();
    }

    SequentialAnimation {
        id: screenBlendOut
        PropertyAnimation {
            target: courtain
            property: "opacity"
            to: 1
            duration: 180
        }
        ScriptAction {
            script: {
                stage.source = Database.currentScreen;
            }
        }
    }

    SequentialAnimation {
        id: screenBlendIn
        PropertyAnimation {
            target: courtain
            property: "opacity"
            to: 0
            duration: 180
        }
    }

    Timer {
        // Need to create the first with minimal delay for valid initial parent.width/height
        interval: 1
        running: true
        onTriggered: switchToScreen("LessonMenu")
    }
}
