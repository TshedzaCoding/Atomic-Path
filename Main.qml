import Backend 1.0
import QtCore
import QtQuick
import QtQuick.Controls
import QtMultimedia

Window {
    width: 390
    height: 840
    visible: true
    title: qsTr("Atomic Path")
    color: "#F5E4C3" // Warm paper brown

    property var habitHistory: ({})
    property var activityData: []
    MediaPlayer {
            id: scratchSound
            audioOutput: AudioOutput {}
            source: "scratch.mp3"
        }

    Text {
        id: dateHeader
        text: Qt.formatDate(new Date(), "dddd, MMMM d")
        font.pixelSize: 24
        font.bold: true
        font.family: "Chalkboard SE"
        color: "black"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
    }

    ListView {
        id: habitList
        anchors.top: dateHeader.bottom
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 30
        topMargin: Math.max(0, (height - contentHeight) / 2)
        model: ListModel {}

        delegate: Component {
            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    checked: model.isDone

                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        x: parent.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: "black"
                        border.width: 2
                        color: parent.checked ? "black" : "white"
                    }

                    onCheckedChanged: {
                                            if (checked !== model.isDone) {
                                                // --- ADDED SOUND LOGIC ---
                                                if (checked) {
                                                    scratchSound.play()
                                                }
                                                // -------------------------

                                                var newCount = checked ? model.completionCount + 1 : Math.max(0, model.completionCount - 1)
                                                habitList.model.setProperty(index, "completionCount", newCount)

                                                var dates = JSON.parse(model.completedDates || "[]")
                                                var today = Qt.formatDate(new Date(), "yyyy-MM-dd")

                                                if (checked && dates.indexOf(today) === -1) {
                                                    dates.push(today)
                                                } else if (!checked) {
                                                    var dateIndex = dates.indexOf(today)
                                                    if (dateIndex !== -1) dates.splice(dateIndex, 1)
                                                }
                                                habitList.model.setProperty(index, "completedDates", JSON.stringify(dates))
                                            }

                                            habitList.model.setProperty(index, "isDone", checked)
                                            saveAllHabits()
                                            updateTodayHistory()
                                        }
                }

                Item {
                    width: habitText.implicitWidth
                    height: habitText.implicitHeight
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: habitText
                        text: model.name
                        font.pixelSize: 24
                        font.family: "Bradley Hand"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Canvas {
                        id: squiggleCanvas
                        anchors.fill: parent
                        visible: model.isDone

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            ctx.strokeStyle = "black";
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.moveTo(0, height / 2 + 2);
                            ctx.quadraticCurveTo(width / 4, height / 2 - 4, width / 2, height / 2 + 1);
                            ctx.quadraticCurveTo(width * 0.75, height / 2 + 6, width, height / 2 - 2);
                            ctx.stroke();
                        }
                        onWidthChanged: requestPaint()
                    }
                }
            }
        }
    }

    Rectangle {
        width: 60
        height: 60
        radius: 30
        color: "black"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20

        Text {
            text: "+"
            color: "white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: addHabitDialog.open()
        }
    }

    Text {
        text: "☰"
        font.pixelSize: 30
        color: "black"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20

        MouseArea {
            anchors.fill: parent
            onClicked: calendarDrawer.open()
        }
    }

    Drawer {
        id: calendarDrawer
        width: parent.width * 0.8
        height: parent.height
        edge: Qt.RightEdge

        background: Rectangle {
            color: "white"
            border.color: "#eeeeee"
        }

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Grid {
                id: heatmapGrid
                columns: 7
                spacing: 5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: activityData
                    Rectangle {
                        width: 25
                        height: 25
                        radius: 4
                        color: {
                            if (modelData === 0) return "#eeeeee"
                            if (modelData === 1) return "#c6e48b"
                            if (modelData === 2) return "#7bc96f"
                            if (modelData === 3) return "#239a3b"
                            return "#196127"
                        }
                    }
                }
            }

            Text {
                id: statsTitle
                text: "Habit Progress"
                font.pixelSize: 20
                font.bold: true
                anchors.top: heatmapGrid.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ListView {
                anchors.top: statsTitle.bottom
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                clip: true
                spacing: 15
                model: habitList.model

                delegate: Row {
                                    spacing: 10
                                    width: parent.width

                                    Text {
                                        text: model.name
                                        font.pixelSize: 16
                                        width: parent.width * 0.35  // Slightly reduced to make room
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: model.completionCount + " / " + getDaysPassed(model.startDate)
                                        font.pixelSize: 16
                                        color: "gray"
                                        width: parent.width * 0.20
                                    }

                                    Text {
                                        text: {
                                            var streaks = getStreaks(model.completedDates || "[]")
                                            return "🔥 " + streaks.current + " | 🏆 " + streaks.longest
                                        }
                                        font.pixelSize: 14
                                        color: "orange"
                                        width: parent.width * 0.25
                                    }

                                    Text {
                                        text: "🗑️"
                                        font.pixelSize: 16
                                        width: parent.width * 0.10  // Explicit width to keep it on screen
                                        horizontalAlignment: Text.AlignRight

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                deleteConfirmDialog.indexToDelete = index
                                                deleteConfirmDialog.open()
                                            }
                                        }
                                    }
                                }
            }
        }
    }

    Dialog {
        id: addHabitDialog
        title: "Add new Habit"
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        padding: 20

        Column {
            spacing: 15
            anchors.centerIn: parent

            TextField {
                id: habitInput
                placeholderText: "What do you want to track?"
                width: 250
            }

            TextField {
                id: startDateInput
                text: Qt.formatDate(new Date(), "yyyy-MM-dd")
                placeholderText: "Start Date (YYYY-MM-DD)"
                width: 250
            }
        }

        onAccepted: {
            habitList.model.append({
                name: habitInput.text,
                isDone: false,
                startDate: startDateInput.text,
                completionCount: 0,
                completedDates: "[]"
            })
            saveAllHabits()
            habitInput.text = ""
            startDateInput.text = Qt.formatDate(new Date(), "yyyy-MM-dd")
        }
    }

    Dialog {
        id: deleteConfirmDialog
        title: "Delete Habit?"
        standardButtons: Dialog.Yes | Dialog.No
        anchors.centerIn: parent
        property int indexToDelete: -1

        Text {
            text: "Are you sure? This will delete all progress."
            padding: 20
        }

        onAccepted: {
            if (indexToDelete !== -1) {
                habitList.model.remove(indexToDelete)
                saveAllHabits()
                updateTodayHistory()
            }
        }
    }

    HabitManager {
        id: backend
    }

    function saveAllHabits() {
        var dataArray = []
        for (var i = 0; i < habitList.model.count; i++) {
            dataArray.push({
                "name": habitList.model.get(i).name,
                "isDone": habitList.model.get(i).isDone,
                "startDate": habitList.model.get(i).startDate,
                "completionCount": habitList.model.get(i).completionCount,
                "completedDates": habitList.model.get(i).completedDates || "[]"
            })
        }
        backend.saveHabits(JSON.stringify(dataArray))
    }

    function getDaysPassed(startDateString) {
        if (!startDateString) return 1
        var start = new Date(startDateString)
        var today = new Date()
        start.setHours(0,0,0,0)
        today.setHours(0,0,0,0)
        var diffTime = today.getTime() - start.getTime()
        var diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
        return diffDays >= 0 ? diffDays + 1 : 0
    }

    function getStreaks(datesJson) {
        if (!datesJson || datesJson === "[]") return { current: 0, longest: 0 }
        var dates = JSON.parse(datesJson)
        if (dates.length === 0) return { current: 0, longest: 0 }
        dates.sort()
        var current = 1
        var longest = 1
        var lastDate = new Date(dates[0])
        lastDate.setHours(0,0,0,0)

        for (var i = 1; i < dates.length; i++) {
            var currDate = new Date(dates[i])
            currDate.setHours(0,0,0,0)
            var diffDays = Math.round((currDate.getTime() - lastDate.getTime()) / (1000 * 60 * 60 * 24))
            if (diffDays === 1) {
                current++
            } else if (diffDays > 1) {
                current = 1
            }
            if (current > longest) longest = current
            lastDate = currDate
        }

        var today = new Date()
        today.setHours(0,0,0,0)
        var daysSinceLast = Math.round((today.getTime() - lastDate.getTime()) / (1000 * 60 * 60 * 24))
        if (daysSinceLast > 1) current = 0

        return { current: current, longest: longest }
    }

    function updateTodayHistory() {
        var completedCount = 0
        for (var i = 0; i < habitList.model.count; i++) {
            if (habitList.model.get(i).isDone) {
                completedCount++
            }
        }
        var today = Qt.formatDate(new Date(), "yyyy-MM-dd")
        habitHistory[today] = completedCount
        backend.saveHistory(JSON.stringify(habitHistory))
        updateHeatmap()
    }

    function updateHeatmap() {
        var newActivityData = []
        var today = new Date()
        for (var i = 34; i >= 0; i--) {
            var pastDate = new Date(today)
            pastDate.setDate(today.getDate() - i)
            var dateString = Qt.formatDate(pastDate, "yyyy-MM-dd")
            if (habitHistory[dateString] !== undefined) {
                newActivityData.push(habitHistory[dateString])
            } else {
                newActivityData.push(0)
            }
        }
        activityData = newActivityData
    }

    Component.onCompleted: {
        var savedData = JSON.parse(backend.loadHabits())
        for (var i = 0; i < savedData.length; i++) {
            habitList.model.append(savedData[i])
        }
        var loadedHistory = JSON.parse(backend.loadHistory())
        habitHistory = loadedHistory
        updateHeatmap()
        var today = Qt.formatDate(new Date(), "yyyy-MM-dd")
        if (appSettings.lastResetDate !== today) {
            for (var j = 0; j < habitList.model.count; j++) {
                habitList.model.setProperty(j, "isDone", false)
            }
            saveAllHabits()
            appSettings.lastResetDate = today
        }
    }

    Settings {
        id: appSettings
        property string lastResetDate: ""
    }
}
